class DockerController
  attr_reader :dc, :cleanup

  def initialize(config: 'docker-compose.yml', cleanup: false)
    @dc = Docker::Compose::Session.new(dir: Rails.root, file: config)
    @cleanup = cleanup
    spec = YAML.safe_load(File.read(Rails.root.join(config)))
    ENV['COMPOSE_PROJECT_NAME'] = spec['x-container-prefix'] if spec.key?('x-container-prefix')
  end

  def status
    containers = dc.ps.map(&:id)
    statuses = containers.map do |container|
      begin
        status = Docker::Container.get(container).info['State']['Health']['Status']
        [container, status]
      rescue
        [container, 'unknown']
      end
    end
    Hash[statuses]
  end

  def wait_for_services
    Timeout.timeout(120) do
      $stderr.print 'Waiting up to two minutes for services to become healthy.'
      loop do
        break if status.all? { |_k, v| v == 'healthy' }
        $stderr.print '.'
        sleep 2
      end
      $stderr.puts
    end
    true
  rescue Timeout::Error
    raise 'Timed out waiting for services to become healthy'
  end

  def run
    dc.up(detached: block_given?)
    return true unless block_given?

    begin
      wait_for_services
      yield
    ensure
      down
    end
  end

  def start(&block)
    old_trap = Signal.trap('INT') do
      down
      raise SystemExit
    end
    run(&block)
  ensure
    Signal.trap('INT', old_trap)
  end
  alias with_containers start

  def down
    dc.run!('down', v: cleanup)
  end
end

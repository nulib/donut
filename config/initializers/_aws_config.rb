require 'aws-sdk-core'

if ENV['SSM_PARAM_PATH']
  require 'aws-sdk-ssm'

  def add_param_to_hash(hash, param, path)
    remove_segments = path.split(%r{/}).length
    placement = param.name.split(%r{/})[remove_segments..-1]
    placement.reject!(&:empty?)
    key = placement.pop
    target = hash
    placement.each { |segment| target = (target[segment] ||= {}) }
    target[key] = param.value
  end

  def aws_param_hash(path: '/')
    result = {}
    ssm = Aws::SSM::Client.new
    next_token = nil
    loop do
      response = ssm.get_parameters_by_path(path: path, recursive: true, max_results: 10, with_decryption: true, next_token: next_token)
      response.parameters.each do |param|
        add_param_to_hash(result, param, path)
      end
      next_token = response.next_token
      break if next_token.nil?
    end
    result
  end

  Settings.add_source!(aws_param_hash(path: "#{ENV['SSM_PARAM_PATH']}/Settings"))
end

def aws_region
  region = Settings.aws_region || Aws.config[:region] || ENV['AWS_REGION'] || ENV['AWS_DEFAULT_REGION']
  if ENV['AWS_EXECUTION_ENV'] == 'AWS_ECS_EC2'
    response = Typhoeus.get('http://169.254.169.254/latest/dynamic/instance-identity/document')
    if response.code == 200
      doc = JSON.parse(response.body)
      region = doc['region']
    end
  end
  region
end

Settings.add_source!(aws_region: aws_region)
Settings.reload!

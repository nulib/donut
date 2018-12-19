class NoOperation
  def rollup_status
    success!
  end

  def rollup_messages
    []
  end

  def pending_job(*args); end

  def performing!(*args); end

  def fail!(*args); end

  def success!(*args); end
end

Hyrax::Operation.class_eval do
  class << self
    alias_method :_find, :find
    def find(*args)
      _find(*args)
    rescue
      NoOperation.new
    end
  end
end

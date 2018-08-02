class CommonIndexService
  def self.index(source)
    index_klass = "CommonIndexers::#{source.class.name}".constantize
    index_klass.new(source).assemble_index
  end
end

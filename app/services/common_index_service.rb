# rubocop:disable Lint/Void
CommonIndexers::AdminSet
CommonIndexers::Collection
CommonIndexers::FileSet
CommonIndexers::Image
# rubocop:enable Lint/Void

class CommonIndexService
  def self.index(source)
    index_klass = "::CommonIndexers::#{source.class.name}".constantize
    index_klass.new(source).generate
  end
end

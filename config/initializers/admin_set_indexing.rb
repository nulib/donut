AdminSet.include(::CommonIndexer::Base)

AdminSet.class_eval do
  def to_common_index
    CommonIndexService.index(self)
  end
end

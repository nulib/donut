namespace :elasticsearch do
  desc 'Initialize common index and mapping'
  task init: :environment do
    CommonIndexer.configure_index!
  end
end

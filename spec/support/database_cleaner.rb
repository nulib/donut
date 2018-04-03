RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion)
    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      ActiveRecord::Base.descendants.each do |klass|
        klass.connection.reset_pk_sequence!(klass.table_name)
      end
    end
  end

  config.before do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :deletion
  end

  config.before do
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end

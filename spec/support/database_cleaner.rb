RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner[:active_record].clean_with(:truncation)
  end

  config.before(:all) do
    DatabaseCleaner[:active_record].strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, :js => true) do
    DatabaseCleaner[:active_record].strategy = :truncation, { :pre_count => true, :reset_ids => false }
  end

  config.before(:each) do
    DatabaseCleaner[:active_record].start
  end

  config.after(:each) do
    DatabaseCleaner[:active_record].clean
  end

  # config.after(:all, :require_cleanup) do
  #   DatabaseCleaner[:active_record].clean_with(:truncation)
  # end

  config.after(:suite) do
    DatabaseCleaner[:active_record].clean_with(:truncation)
  end

end

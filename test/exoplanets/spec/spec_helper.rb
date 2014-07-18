require 'rubygems'

module ActiveModel
  module Observing
  end
end

require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'

  require 'rails/application'
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  root = Rails.root

  include ActionDispatch::TestProcess

  RSpec.configure do |config|

    config.include EmailSpec::Helpers
    config.include EmailSpec::Matchers
    config.include Devise::TestHelpers, :type => :controller
    config.include FactoryGirl::Syntax::Methods

    Dir[root.join("spec/support/matchers/*.rb")].each {|f| require f }

    require root.join('spec/support/helpers/base_helper.rb')
    Dir[root.join("spec/support/helpers/*.rb")].each do |f|
      const = f.split("/").last.split(".").first.classify.constantize
      RSpec::Core::ExampleGroup.send :include, const
    end

    I18n.locale = :en

    config.fixture_path = "#{root}/spec/fixtures"

    config.use_transactional_fixtures = true

    config.infer_base_class_for_anonymous_controllers = false

    config.alias_it_should_behave_like_to :it_should, "it should"

    config.order = "random"

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
    end
    config.before(:each) do
      DatabaseCleaner.start
    end
    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end

Spork.each_run do
  FactoryGirl.reload
end

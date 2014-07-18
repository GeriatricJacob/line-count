module SessionHelper
  extend BaseHelper

  module ExampleMethods
    def setup_devise
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    def login user
      user = FactoryGirl.create(user) if user.is_a? Symbol

      @current_user = user
      setup_devise
      sign_in user
    end

    def auth user, opts={}
      user = FactoryGirl.create(user) if user.is_a? Symbol
      ActiveSupport::OptionMerger.new self, opts.merge(auth_token: user.authentication_token)
    end

    def json opts={}
      ActiveSupport::OptionMerger.new self, opts.merge(format: :json)
    end

    def json_response
      response.body && JSON.parse(response.body)
    end
  end

  module ExampleGroupMethods
    def as_user(options={})
      {
        factory: :user,
        label: 'user'
      }.merge(options)
    end

    def as_admin(options={})
      {
        factory: :admin,
        label: 'admin'
      }.merge(options)
    end

    def when_logged_in(options={}, &block)

      if options[:as].present?
        label = factory = options[:as]
        traits = []
      elsif options[:factory].present?
        factory = options[:factory]
        label = options[:label] || factory
        traits = options[:traits] || []
      else
        label = factory = :user
        traits = []
      end

      proc = options[:do]

      context "when logged in as #{label}" do
        let(:user) do
          u = create factory, *traits
          proc.bind(self).call(u) if proc
          u
        end

        before(:each) { sign_in user }

        context('', &block) if block_given?
      end
    end
  end
end

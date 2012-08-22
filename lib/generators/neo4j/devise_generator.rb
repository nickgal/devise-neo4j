require 'generators/devise/orm_helpers'

module Neo4j
  module Generators
    class DeviseGenerator < ::Rails::Generators::NamedBase
      include ::Devise::Generators::OrmHelpers
      
      def generate_model
        invoke "neo4j:model", [name] unless model_exists? && behavior == :invoke
      end

      def inject_devise_content
        content = model_contents + <<CONTENT
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
CONTENT

        class_path = class_name.to_s.split("::")

        indent_depth = class_path.size - 1
        content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"

        inject_into_class(model_path, class_path.last, content) if model_exists?
      end

      def migration_data
<<RUBY
  ## Database authenticatable
  property :email, :index => :exact
  property :encrypted_password

  validates_presence_of :email
  validates_presence_of :encrypted_password
  
  ## Recoverable
  property :reset_password_token, :index => :exact
  property :reset_password_sent_at

  ## Rememberable
  property :remember_created_at

  ## Trackable
  property :sign_in_count
  property :current_sign_in_at
  property :last_sign_in_at
  property :current_sign_in_ip
  property :last_sign_in_ip

  ## Confirmable
  # property :confirmation_token, :index => :exact
  # property :confirmed_at
  # property :confirmation_sent_at
  # property :unconfirmed_email, :index => :exact # Only if using reconfirmable

  ## Lockable
  # property :failed_attempts # Only if lock strategy is :failed_attempts
  # property :unlock_token, :index => :exact # Only if unlock strategy is :email or :both
  # property :locked_at

  ## Token authenticatable
  # property :authentication_token, :index => :exact
RUBY
      end
    end
  end
end

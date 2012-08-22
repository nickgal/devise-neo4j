require 'generators/devise/orm_helpers'

module Neo4j
  module Generators
    class DeviseGenerator < ::Rails::Generators::NamedBase
      include ::Devise::Generators::OrmHelpers
      
      def generate_model
        invoke "neo4j:model", [name] unless model_exists? && behavior == :invoke
      end

      def inject_devise_content
        pre_content = <<PRE_CONTENT
## Database authenticatable
  property :email,                  :type => String, :default => "", :null => false, :index => :exact
  property :encrypted_password,     :type => String

  validates :email, :presence => true, :uniqueness => true
  validates :encrypted_password, :presence => true
  
  ## Recoverable
  property :reset_password_token,   :type => String
  property :reset_password_sent_at, :type => Time

  index :reset_password_token

  ## Rememberable
  property :remember_created_at,    :type => Time

  ## Trackable
  property :sign_in_count,          :type => Fixnum, :default => 0
  property :current_sign_in_at,     :type => Time
  property :last_sign_in_at,        :type => Time
  property :current_sign_in_ip,     :type => String
  property :last_sign_in_ip,        :type => String

  ## Confirmable
  # property :confirmation_token,   :type => String, :index => :exact
  # property :confirmed_at,         :type => Time
  # property :confirmation_sent_at, :type => Time
  # property :unconfirmed_email,    :type => String, :index => :exact # Only if using reconfirmable
  
  ## Lockable
  # property :failed_attempts,      :type => Fixnum, :default => 0    # Only if lock strategy is :failed_attempts
  # property :unlock_token,         :type => String, :index => :exact # Only if unlock strategy is :email or :both
  # property :locked_at,            :type => Time
  
  ## Token authenticatable
  # property :authentication_token, :type => String, :index => :exact

PRE_CONTENT
       
        content = pre_content + model_contents + <<CONTENT
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
CONTENT
        class_path = class_name.to_s.split("::")

        indent_depth = class_path.size - 1
        content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"

        inject_into_class(model_path, class_path.last, content) if model_exists?
      end
    end
  end
end

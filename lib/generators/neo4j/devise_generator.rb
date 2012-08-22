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

  ## Database authenticatable
  property :email,                  :type => String, :default => "", :null => false
  property :encrypted_password,     :type => String

  index :email

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :encrypted_password
  
  ## Recoverable
  property :reset_password_token,   :type => String
  property :reset_password_sent_at, :type => DateTime

  index :reset_password_token

  ## Rememberable
  property :remember_created_at,    :type => DateTime

  ## Trackable
  property :sign_in_count,          :type => Integer, :default => 0
  property :current_sign_in_at,     :type => DateTime
  property :last_sign_in_at,        :type => DateTime
  property :current_sign_in_ip,     :type => String
  property :last_sign_in_ip,        :type => String

  ## Confirmable
  # property :confirmation_token,   :type => String
  # property :confirmed_at,         :type => DateTime
  # property :confirmation_sent_at, :type => DateTime
  # property :unconfirmed_email,    :type => String # Only if using reconfirmable
  #
  # index :confirmation_token
  # index :unconfirmed_email

  ## Lockable
  # property :failed_attempts,      :type => Integer, :default => 0    # Only if lock strategy is :failed_attempts
  # property :unlock_token,         :type => String # Only if unlock strategy is :email or :both
  # property :locked_at,            :type => DateTime
  #
  # index :unlock_token

  ## Token authenticatable
  # property :authentication_token, :type => String
  #
  # index :authentication_token
CONTENT

        class_path = class_name.to_s.split("::")

        indent_depth = class_path.size - 1
        content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"

        inject_into_class(model_path, class_path.last, content) if model_exists?
      end
    end
  end
end

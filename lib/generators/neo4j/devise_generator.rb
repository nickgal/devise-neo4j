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

        inject_into_class(model_path, class_path.last, content) if model_exists?end
    end
  end
end

require 'shared_user'

class User < Neo4j::Rails::Model
  include Shim
  include SharedUser

  property   :username, :index => :exact

  attr_accessible :username, :email, :password, :password_confirmation, :remember_me
end

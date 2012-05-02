require 'shared_admin'

class Admin < Neo4j::Rails::Model
  include Shim
  include SharedAdmin
  
  property   :remember_token, :index => :exact
end

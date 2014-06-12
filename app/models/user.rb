class User
  include Mongoid::Document
  field :email, type: String
  field :login, type: String
end

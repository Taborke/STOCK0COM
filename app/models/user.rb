class User
  include Mongoid::Document
  field :email, type: String
  validates_presence_of :email
  validates_uniqueness_of :email

  
   # Access token for a user
  def access_token
    User.create_access_token(self)
  end

  # Verifier based on our application secret
  def self.verifier
    
    ActiveSupport::MessageVerifier.new(STOCK0COM::Application.config.secret_token)
  end

  # Get a user from a token
  def self.read_access_token(signature)
    id = verifier.verify(signature)
    User.find_by_id id
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end

  # Class method for token generation
  def self.create_access_token(user)        
    User.verifier.generate(user.id)    
  end
end

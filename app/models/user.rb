class User
  include Mongoid::Document
  field :email, type: String
  validates_presence_of :email
  validates_uniqueness_of :email
  #This model validates each email is a unique email to prevents duplicates
  #these methods create an access token to allow users to unsubscribe with their
  #unique token url sent to them in the welcome email


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
    User.find(id)
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end

  # Class method for token generation
  def self.create_access_token(user)        
    User.verifier.generate(user.id)    
  end
end

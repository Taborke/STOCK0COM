class UserMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def welcome_email(user)
  	@user = user
  	@url = 'http://glacial-eyrie-4756.herokuapp.com'
  	mail(to: @user.email, subject: 'Welcome to SCHTOCK0COM')
  end
end

class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def welcome_email(user)
  	@user = user
  	@url = 'zombo.com'
  	mail(to: @user.email, subject: 'Welcome to SCHTOCK0COM')
  end
end

class UserMailer < ActionMailer::Base
  default from: "SCHTOCK0COM"

  def welcome_email(user)
  	@user = user
  	@url = 'http://glacial-eyrie-4756.herokuapp.com'
  	mail(to: @user.email, subject: 'Welcome to SCHTOCK0COM')
  end

  def dist_day_email(days)
     #send to all users
     @dist_days = days #array of stock histories with dist days
     @stock = @dist_days.last.stock
     @stock = @stock.name
     @day_count = @dist_days.length #variable for dist day count
     @emails = User.all
     users = @emails.collect(&:email).join(",")
     mail(bcc: users, subject: "#{@stock} has had a distribution day")
  end
end

class UserMailer < ActionMailer::Base
  default from: "asteroid.daily@gmail.com"
  
  # daily newspaper, should pass in a user object to this call
  def daily_newspaper()
    @url = "http://localhost:3000/users/confirm"
    mail( to: "yuhua.xie@gmail.com", subject: "Your Daily Minor Planet" )
  end

  def daily_batch()
  	# loop through each 'active' user, and send out email
  end

  def verify_email()
    @url = "http://localhost:3000/users/confirm"
    mail( to: "yuhua.xie@gmail.com", subject: "Email verfication - Daily Minor Planet" )
  end
end

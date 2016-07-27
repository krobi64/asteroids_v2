class UserMailer < ActionMailer::Base
  default from: "asteroid.daily@gmail.com"
  
  # daily newspaper, should pass in a user object to this call
  def daily_newspaper(edition, email)
    @edition = edition
    @email = email

    # 2016-07-23T07:00:00Z
    # pDate = Date.strptime(edition.publish_date[0..10], "%Y-%m-%d")
    pDate = edition.publish_date
    @weekday = pDate.strftime('%A')
    @year = pDate.strftime('%Y')
    @month = pDate.strftime('%B')
    @day = pDate.strftime('%-d')

    mail( to: email, subject: "Your Daily Minor Planet" )
  end

  def daily_batch()
  	# loop through each 'active' user, and send out email
    # @users = User.all
    User.find_each do |user|
      mail(to: user.email, subject: "Your Daily Minor Planet" )
    end
  end

  def verify_email()
    @url = "http://localhost:3000/users/confirm"
    mail( to: "yuhua.xie@gmail.com", subject: "Email verfication - Daily Minor Planet" )
  end
end

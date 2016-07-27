class DmpController < ApplicationController
  respond_to :json, :html

  def index
  end

  def draft
  end

  def testemail
  	@edition = Edition.current.first
  	@email = "yuhua.xie@gmail.com"
  	UserMailer.daily_newspaper(@edition, @email).deliver
  	# UserMailer.verify_email().deliver
  end
end

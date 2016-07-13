class DmpController < ApplicationController
  respond_to :json, :html

  def index
  end

  def draft
  end

  def testemail
  	# UserMailer.daily_newspaper().deliver
  	# UserMailer.verify_email().deliver
  end
end

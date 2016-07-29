class DmpController < ApplicationController
  include CanCan::ControllerAdditions
  respond_to :json, :html

  def index
  end

  def draft
    @edition = Edition.draft
    authorize!(:manage, @edition)
  end

  def testemail
  	@edition = Edition.current
  	user = User.last
  	UserMailer.daily_newspaper(user, @edition).deliver
  	# UserMailer.verify_email().deliver
  end
end

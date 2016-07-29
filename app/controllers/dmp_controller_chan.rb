class DmpController < ApplicationController
  include CanCan::ControllerAdditions
  respond_to :json, :html

  def index
  end

  def draft
    @edition = Edition.draft.first
    authorize!(:manage, @edition)
  end

  def testemail
  	 UserMailer.daily_newspaper().deliver
  	# UserMailer.verify_email().deliver
  end
end

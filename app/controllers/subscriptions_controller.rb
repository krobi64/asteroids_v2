# -*- encoding : utf-8 -*-

class SubscriptionsController < ApplicationController

  respond_to :html, :json

  def subscribe
    generated_password = Devise.friendly_token.first(8)
    @user = User.where(user_params).first_or_create do |u|
      u.password = generated_password
      u.password_confirmation = generated_password
    end
    @user.subscribe!
    render json: @user, status: :created
  end

  def unsubscribe
    @user = User.find_by_id(params[:user_id])
    @user.unsubscribe!
    head :no_content
  end

  private

  def user_params
    params.slice(:email, :username)
  end
end

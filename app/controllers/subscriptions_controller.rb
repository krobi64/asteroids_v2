# -*- encoding : utf-8 -*-

class SubscriptionsController < ApplicationController

  respond_to :html, :json

  def subscribe
    @user = User.first_or_create(user_params) do |u|
      u.password = params[:password]
      u.password_confirmation = params[:password_confirmation]
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

# -*- encoding : utf-8 -*-

class SubscriptionsController < ApplicationController

  respond_to :html, :json

  def subscribe
    response = { status: 'success' }
    if User.where(email: user_params[:email]).present?
      response = {
          status: 'error',
          message: 'Email already subscribed'
      }
    else
      generated_password = Devise.friendly_token.first(8)
      @user = User.create(user_params.merge(password: generated_password, password_confirmation: generated_password))
    end
    if @user.valid?
      @user.subscribe!
    else
      response = {
          status: 'error',
          message: @user.errors.messages
      }
    end

    render json: response, status: response[:status] == 'success' ? :created : :unprocessable_entity
  end

  def unsubscribe
    @user = User.find_by_id(params[:user_id])
    if @user.present?
      @user.unsubscribe!
      head :no_content
    else
      render json: { error: 'subscription not found' }, status: :not_found
    end
  end

  private

  def user_params
    params.slice(:email, :username)
  end
end

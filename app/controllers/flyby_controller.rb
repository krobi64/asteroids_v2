# -*- encoding : utf-8 -*-

class FlybyController < ApplicationController
  respond_to :json

  def orbit_params
    @orbit_params = Property.designation(params[:designation]).try(:image_properties)
    render json: @orbit_params
  end

  def search
    @asteroids = Asteroid.search(params[:designation])
    render json: @asteroids
  end
end

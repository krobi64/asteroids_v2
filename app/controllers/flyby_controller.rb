# -*- encoding : utf-8 -*-

class FlybyController < ApplicationController
  respond_to :json

  def search
    @asteroids = Asteroid.search(params[:designation])
  end
end

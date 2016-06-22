class AsteroidExplorersController < ApplicationController

  respond_to :json, :html

  def asteroid_data
    @asteroids= Asteroid.all
    respond_with(@asteroids)
  end

  def show
    @asteroid = Asteroid[params[:id]]
  end

  def index

  end

  def cpanel
    @filter_type = params[:filter_type]
  end

  def about

  end

  def daily

  end

end

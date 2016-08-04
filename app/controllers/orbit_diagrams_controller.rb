# -*- encoding : utf-8 -*-

class OrbitDiagramsController < ApplicationController
  respond_to :json

  def orbit_params
    @orbit_params = Property.designation(params[:designation]).try(:image_properties)
    render json: @orbit_params
  end

  def static_image
    if params[:fileData].present?
      OrbitDiagram.create_static_image params[:date], params[:fileData]
      render json: {status: 'success'}, status: 201
    else
      render json: { error: 'No data present' }, status: :unprocessable_entity
    end
  end
end

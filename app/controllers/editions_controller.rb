class EditionsController < ApplicationController
  respond_to :json, :html

  before_filter :load_model, only: [:show, :edit, :update, :share, :publish]

  def index
    respond_with (@editions = model.limit(25))
  end

  def new
    respond_with (@edition = model.new)
  end

  def current
    respond_with model.current.first
  end

  def show
    respond_with @edition
  end

  def edit
    respond_with @edition
  end

  def create
    respond_with Edition.create(edition_params)
  end

  def update
    respond_with @edition.update_attributes(edition_params)
  end

  def share
    @edition.share(params[:social_type])
    respond_with @edition
  end

  def publish
    @edition.publish
    respond_with @edition
  end

  private

  def model
    Edition.includes(:flyby, :orbit_diagram, :news_story, :theme)
  end

  def load_model
    @edition ||= model.find_by_id(Integer(params[:id]))
  end

  def edition_params
    params.slice(:publish_date, :state, :title, :news_story, :flyby, :orbit_diagram, :theme)
  end
end

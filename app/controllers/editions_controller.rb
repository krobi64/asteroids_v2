class EditionsController < ApplicationController
  respond_to :json, :html

  before_filter :load_model, only: [:show, :edit, :update, :share, :publish]

  def index
    respond_with Edition.limit(25)
  end

  def current
    respond_with Edition.current
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

  def load_model
    @edition ||= Edition.find_by_id(Integer(params[:id]))
  end

  def edition_params
    params.slice(:publish_date, :state, :title, :news_story, :flyby, :orbit_diagram, :theme)
  end
end

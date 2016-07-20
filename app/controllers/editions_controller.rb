class EditionsController < ApplicationController
  respond_to :json, :html

  before_filter :load_model, only: [:show, :edit, :update, :share, :publish]

  def index
    respond_with (@editions = model_date_range)
  end

  def new
    respond_with (@edition = Edition.new)
  end

  def current
    respond_with model.current.first
  end

  def draft
    respond_with model.draft.first
  end

  def show
    respond_with @edition
  end

  def edit
    respond_with @edition
  end

  def create
    @edition = Edition.create edition_params
    @edition.create_flyby flyby_params
    @edition.create_news_story news_story_params
    @edition.create_orbit_diagram orbit_diagram_params
    @edition.theme = theme_from_params
    @edition.save
    respond_with @edition
  end

  def update
    @edition.update_attributes edition_params
    @edition.flyby.update_attributes flyby_params
    @edition.news_story.update_attributes news_story_params
    @edition.orbit_diagram.update_attributes orbit_diagram_params
    @edition.theme = theme_from_params
    respond_with @edition.save
  end

  def share
    @edition.share(params[:channel])
    respond_with @edition
  end

  def publish
    if @edition.draft?
      @edition.publish!
    else
      @edition.errors.add(:state, 'Edition already published')
    end
    respond_with @edition
  end

  private

  def model
    Edition.includes(:flyby, :orbit_diagram, :news_story, :theme)
  end

  def model_date_range
    from = DateTime.parse(params[:from]) if params[:from].present?
    to = DateTime.parse(params[:to]) if params[:to].present?
    Edition.in_date_range(from, to)
  end

  def load_model
    @edition ||= model.find_by_id(Integer(params[:id]))
  end

  def edition_params
    params.slice(:state, :title, :publish_date)
  end

  def flyby_params
    params[:flyby]
  end

  def news_story_params
    params[:news_story]
  end

  def orbit_diagram_params
    params[:orbit_diagram]
  end

  def theme_from_params
    params[:theme].try(:[], :name) == 'modern' ? Theme.modern : Theme.classic
  end
end

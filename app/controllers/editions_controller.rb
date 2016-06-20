class EditionsController < ApplicationController
  include LoremIpsum::Base
  respond_to :json, :html

  before_filter :load_model, only: [:show, :edit, :update, :share, :publish]

  def index
    respond_with @editions = (1..5).map { |n| sample_data(n) }  #Edition.limit(25)
  end

  def new
    respond_with @edition = Edition.new
  end

  def current
    respond_with @edition = Edition.current
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

  def sample_data(n=1)
    {
        id:  n,
        title: "News Title for #{n}",
        flyby_title: "Asteroid M12#{n} is heading toward us",
        flyby_content: "Check it out #{n} days from now",
        news_title: "News of #{Date.yesterday - n.days}",
        news_content: lorem_ipsum('2p').gsub(/<p>/, '').gsub(/<\/p>/, "\n").gsub(/\n\n/, "\n"),
        orbit_url: sample_orbit,
        publish_date: Date.yesterday - n.days
    }
  end

  def sample_orbit
    Asteroid.all.sample['url']
  end

  def load_model
    @edition ||= Edition.find_by_id(Integer(params[:id]))
  end

  def edition_params
    params.slice(:publish_date, :state, :title, :news_story, :flyby, :orbit_diagram, :theme)
  end
end

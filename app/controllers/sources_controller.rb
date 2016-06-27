class SourcesController < ApplicationController
  include LoremIpsum::Base
  respond_to :json, :html

  def index
    respond_with Source.all
  end

  def latest
    @source = Source.find_by_id(params[:id])
    respond_with stub_story.to_json
  end

  private
  def stub_story
    {
      source_id: @source.id,
      source_url: @source.url,
      story_url: "#{@source_url}/and_more_links",
      story: lorem_ipsum('2p').gsub(/<p>/, '').gsub(/<\/p>/, "\n").gsub(/\n\n/, "\n")
    }
  end
end

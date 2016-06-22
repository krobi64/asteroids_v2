class DmpController < ApplicationController
  respond_to :json, :html

  before_filter :load_model, only: [:show, :edit, :update, :share, :publish]

  def index

  end

  def images
  end
end

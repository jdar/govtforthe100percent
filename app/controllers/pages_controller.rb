class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout 'splash', only: [:index]
  def index
    @experience = Experience.first
  end
end

class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout 'splash', only: [:index]
  def index
    @experience = Experience.find(34) || Experience.first
  end
end

class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout 'splash', only: [:index]
  def index
    @experience = Experience.where(id: 34).first || Experience.first
  end
end

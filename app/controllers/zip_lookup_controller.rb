
class ZipLookupController < ApplicationController
  def index
    render json: []
  end
  def get
    render json: AppConstants::ZIP_LOOKUP[params['zip_code']]
  end
end

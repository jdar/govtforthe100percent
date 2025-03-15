# NOTE: In the dataset on which the application is based, UNISEX is coded by 0, ADA
# (accessible) is coded by 1

class Experience < ApplicationRecord
  include PgSearch::Model
  include Rakismet::Model

  pg_search_scope(
    :search,
    against: {
      zip_code: 'A',
      federal_agency: 'B',
      agency_website: 'C',
      experience: 'D',
      immediate_results: 'E',
      experience_details: 'F',
      title: 'G',
      #open_to_contact: 'G'
=begin
      name: 'A',
      street: 'B',
      city: 'C',
      state: 'D',
      comment: 'B',
      directions: 'B',
      country: 'D'
=end
    },
    using: { tsearch: { dictionary: "english" } },
    ignoring: :accents
  )

  #validates :name, :street, :city, :state, presence: true
  validates :federal_agency, :experience, :title, :experience_details, presence: true, string: true
  validates :zip_code, inclusion: { in: AppConstants::ZIP_LOOKUP.keys, message: " was not a known zipcode in US, PR, or outlying islands." }

  #,
  #:open_to_contact,


  geocoded_by :full_address

  reverse_geocoded_by :latitude, :longitude do |obj, results|
    geo = results.first
    if geo
      obj.name    = geo.address
      obj.street  = geo.address.split(',').first
      obj.city    = geo.city
      obj.state   = geo.state
      obj.country = geo.country_code
    end
  end

  rakismet_attrs content: proc {
    #check permitted attrs in controller, if null
    [zip_code, federal_agency, agency_website, experience, immediate_results, title, experience_details].map(&:to_s).join(" ")
    #[zip_code, federal_agency, agency_website, experience, experience_details].map(&:to_s).join(" ")
  }

  #after_validation :perform_geocoding
  after_validation :populate_from_zip_properties
  after_find :strip_slashes

  scope :current, lambda {
    Experience.where('id IN (SELECT MAX(id) FROM experiences WHERE approved GROUP BY edit_id)')
  }

  scope :accessible, -> { where(accessible: true) }
  scope :changing_table, -> { where(changing_table: true) }
  scope :unisex, -> { where(unisex: true) }

  scope :created_since, ->(date) { where("created_at >= ?", date) }
  scope :updated_since, ->(date) { where("updated_at >= ?", date) }

  def full_address
    #"#{street}, #{city}, #{state}, #{country}"
    "#{zip_code}"
  end

  def rated?
    upvote.positive? || downvote.positive?
  end

  def rating_percentage
    return 0 unless rated?

    upvote.to_f / (upvote + downvote) * 100
  end

  # PostgreSQL Full-Text Search for the API.
  def self.text_search(query)
    if query.present?
      search(query)
    else
      all
    end
  end

  private

  def strip_slashes
    #%w[name street city state comment directions].each do |field|
    %w[zip_code federal_agency agency_website experience immediate_results title experience_details ].each do |field|
      attributes[field].try(:gsub!, "\\'", "'")
    end
    #TODO: search by open_to_contact
  end

  def perform_geocoding
    return true if Rails.env.test?
    return true if ENV["SEEDING_DONT_GEOCODE"]

    geocode
  end
  def populate_from_zip_properties
    return true if Rails.env.test?
    return true if ENV["SEEDING_DONT_GEOCODE"]
    zip_properties = AppConstants::ZIP_LOOKUP[zip_code]
    if(zip_properties)
      self.state = zip_properties["State"]
      self.city = zip_properties['City'] || 'Rural'
      self.country = ['PR'].include?(zip_properties['State']) ? zip_properties['State'] : "United States"
      self.latitude = zip_properties["Latitude"]
      self.longitude = zip_properties["Longitude"]
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["accessible", "agency_website", "approved", "changing_table", "city", "comment", "contact_email", "contact_name", "contact_phone", "country", "created_at", "directions", "downvote", "edit_id", "experience", "title", "experience_details", "federal_agency", "id", "id_value", "immediate_results", "latitude", "longitude", "name", "open_to_contact", "state", "street", "unisex", "updated_at", "upvote", "zip_code"]
  end

end
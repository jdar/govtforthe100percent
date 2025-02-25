require 'spec_helper'

describe API::V1::Experiences do
  it 'sends a list of experiences order by date descending' do
    create_list(:experience, 15)

    get '/api/v1/experiences'
    expect(response).to have_http_status(:success)

    json = JSON.parse(response.body)
    previous_record = nil
    json.each do |rest_json|
      experience = Experience.find(rest_json['id'])
      expect(experience.valid?).to be true
      # TODO: this assertion doesn't seem to ever run
      expect(experience.created_at).to be >= previous_record.created_at if previous_record.present?
    end
  end

  it 'does not list experience edits' do
    create(:experience, id: 1)
    edit = create(:experience)
    edit.update(approved: false, edit_id: 1)

    get '/api/v1/experiences'
    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json.length).to eq(1)
  end

  it 'paginates list of experiences by 10 results' do
    create_list(:experience, 15)

    get '/api/v1/experiences'
    expect(response).to have_http_status(:success)

    json = JSON.parse(response.body)
    expect(json.length).to eq(10)

    expect(response.header['X-Per-Page']).to eq('10')
    expect(response.header['X-Page']).to eq('1')
    expect(response.header['X-Total-Pages']).to eq('2')
    expect(response.header['X-Total']).to eq('15')
  end

  describe 'filters' do
    before do
      create_list(:experience, 5)
      create_list(:unisex_experience, 5)
      create_list(:ada_experience, 5)
      create_list(:unisex_and_ada_experience, 5)
    end

    let(:json) { JSON.parse(response.body) }

    context 'when requesting a list of unisex experiences' do
      before do
        get '/api/v1/experiences', params: { unisex: true }
      end

      it "is successful" do
        expect(response).to have_http_status(:success)
      end

      it "returns unisex restro3ms" do
        expect(json.select { |experience| experience["unisex"] }.count).to eq 10
      end

      it "does not return non-unisex experiences" do
        expect(json.reject { |experience| experience["unisex"] }.count).to eq 0
      end
    end

    context 'when requesting a list of experiences by ADA availability' do
      before do
        get '/api/v1/experiences', params: { ada: true }
      end

      it "is successful" do
        expect(response).to have_http_status(:success)
      end

      it "returns accessible experiences" do
        expect(json.select { |experience| experience["accessible"] }.count).to eq 10
      end

      it "does not return non-accessible experiences" do
        expect(json.reject { |experience| experience["accessible"] }.count).to eq 0
      end
    end
  end

  it 'full-text searches a list of experiences' do
    create(:experience, name: 'Moonlight Café')
    create(:experience, name: 'Frankie\'s Coffee Shop')
    create(:experience, name: 'Hipster Coffee Shop')
    create(:experience, name: 'Organic Co. Coffee', comment: 'Pretty tile.')

    get '/api/v1/experiences/search', params: { query: 'Coffee Shop' }
    json = JSON.parse(response.body)
    expect(json.length).to eq(2)
    json.each do
      expect(json[0]['name']).to match(/Coffee Shop/)
    end

    # Tests the full-text unaccent extensions
    get '/api/v1/experiences/search', params: { query: 'Cafe' }
    json = JSON.parse(response.body)
    expect(json.length).to eq(1)
    expect(json[0]['name']).to eq('Moonlight Café')

    # Tests the full-text searching capability of multiple string attributes
    get '/api/v1/experiences/search', params: { query: 'Organic pretty tile' }
    json = JSON.parse(response.body)
    expect(json.length).to eq(1)
    expect(json[0]['name']).to eq('Organic Co. Coffee')
  end

  it 'paginates full-text searches a list of experiences by 10 results' do
    create_list(:experience, 15)

    get '/api/v1/experiences/search', params: { query: 'San Francisco' }
    expect(response).to have_http_status(:success)

    json = JSON.parse(response.body)
    expect(json.length).to eq(10)

    expect(response.header['X-Per-Page']).to eq('10')
    expect(response.header['X-Page']).to eq('1')
    expect(response.header['X-Total-Pages']).to eq('2')
    expect(response.header['X-Total']).to eq('15')
  end

  describe "queries" do
    before do
      create(:experience)
      create(:unisex_experience, name: 'Frankie\'s Coffee Shop')
      create(:ada_experience, name: 'Hipster Coffee Shop')
      create(:unisex_and_ada_experience, name: 'Organic Co. Coffee', comment: 'Pretty tile.')
    end

    let(:json) { JSON.parse(response.body) }

    context 'when looking for unisex experiences and given a search query' do
      before do
        get '/api/v1/experiences/search', params: { query: 'Coffee', unisex: true }
      end

      it "is successful" do
        expect(response).to have_http_status(:success)
      end

      it "finds two coffeeshops with unisex experiences" do
        expect(json.length).to eq(2)
      end

      it "returns accessible experiences" do
        expect(json.select { |experience| experience["unisex"] }.count).to eq 2
      end

      it "does not return non-accessible experiences" do
        expect(json.reject { |experience| experience["unisex"] }.count).to eq 0
      end
    end

    context 'when searching for ADA accessible experiences and given a search query' do
      before do
        get '/api/v1/experiences/search', params: { query: 'Coffee', ada: true }
      end

      it "is successful" do
        expect(response).to have_http_status(:success)
      end

      it "finds two coffeeshops with accessible experiences" do
        expect(json.length).to eq(2)
      end

      it "returns accessible experiences" do
        expect(json.select { |experience| experience["accessible"] }.count).to eq 2
      end

      it "does not return non-accessible experiences" do
        expect(json.reject { |experience| experience["accessible"] }.count).to eq 0
      end
    end

    context "when looking for experiences by updated date" do
      before do
        create(:experience, created_at: 1.day.ago)
        params = {
          updated: true,
          day: Time.current.day,
          month: Time.current.month,
          year: Time.current.year
        }
        get "/api/v1/experiences/by_date", params:
      end

      it "is successful" do
        expect(response).to have_http_status(:success)
      end

      it "finds all experiences" do
        expect(json.length).to eq(5)
      end
    end

    context "when filtering by created date" do
      before do
        create(:experience, created_at: 1.week.ago)
        params = {
          day: Time.current.day,
          month: Time.current.month,
          year: Time.current.year
        }
        get "/api/v1/experiences/by_date", params:
      end

      it "is successful" do
        expect(response).to have_http_status(:success)
      end

      it "finds all but one of the experiences" do
        expect(json.length).to eq(4)
      end
    end
  end
end

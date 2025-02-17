require 'spec_helper'

describe API::V1::Travesties do
  it 'sends a list of travesties order by date descending' do
    create_list(:travesty, 15)

    get '/api/v1/travesties'
    expect(response).to have_http_status(:success)

    json = JSON.parse(response.body)
    previous_record = nil
    json.each do |rest_json|
      travesty = Travesty.find(rest_json['id'])
      expect(travesty.valid?).to be true
      # TODO: this assertion doesn't seem to ever run
      expect(travesty.created_at).to be >= previous_record.created_at if previous_record.present?
    end
  end

  it 'does not list travesty edits' do
    create(:travesty, id: 1)
    edit = create(:travesty)
    edit.update(approved: false, edit_id: 1)

    get '/api/v1/travesties'
    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json.length).to eq(1)
  end

  it 'paginates list of travesties by 10 results' do
    create_list(:travesty, 15)

    get '/api/v1/travesties'
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
      create_list(:travesty, 5)
      create_list(:unisex_travesty, 5)
      create_list(:ada_travesty, 5)
      create_list(:unisex_and_ada_travesty, 5)
    end

    let(:json) { JSON.parse(response.body) }

    context 'when requesting a list of unisex travesties' do
      before do
        get '/api/v1/travesties', params: { unisex: true }
      end

      it "is successful" do
        expect(response).to have_http_status(:success)
      end

      it "returns unisex restro3ms" do
        expect(json.select { |travesty| travesty["unisex"] }.count).to eq 10
      end

      it "does not return non-unisex travesties" do
        expect(json.reject { |travesty| travesty["unisex"] }.count).to eq 0
      end
    end

    context 'when requesting a list of travesties by ADA availability' do
      before do
        get '/api/v1/travesties', params: { ada: true }
      end

      it "is successful" do
        expect(response).to have_http_status(:success)
      end

      it "returns accessible travesties" do
        expect(json.select { |travesty| travesty["accessible"] }.count).to eq 10
      end

      it "does not return non-accessible travesties" do
        expect(json.reject { |travesty| travesty["accessible"] }.count).to eq 0
      end
    end
  end

  it 'full-text searches a list of travesties' do
    create(:travesty, name: 'Moonlight Café')
    create(:travesty, name: 'Frankie\'s Coffee Shop')
    create(:travesty, name: 'Hipster Coffee Shop')
    create(:travesty, name: 'Organic Co. Coffee', comment: 'Pretty tile.')

    get '/api/v1/travesties/search', params: { query: 'Coffee Shop' }
    json = JSON.parse(response.body)
    expect(json.length).to eq(2)
    json.each do
      expect(json[0]['name']).to match(/Coffee Shop/)
    end

    # Tests the full-text unaccent extensions
    get '/api/v1/travesties/search', params: { query: 'Cafe' }
    json = JSON.parse(response.body)
    expect(json.length).to eq(1)
    expect(json[0]['name']).to eq('Moonlight Café')

    # Tests the full-text searching capability of multiple string attributes
    get '/api/v1/travesties/search', params: { query: 'Organic pretty tile' }
    json = JSON.parse(response.body)
    expect(json.length).to eq(1)
    expect(json[0]['name']).to eq('Organic Co. Coffee')
  end

  it 'paginates full-text searches a list of travesties by 10 results' do
    create_list(:travesty, 15)

    get '/api/v1/travesties/search', params: { query: 'San Francisco' }
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
      create(:travesty)
      create(:unisex_travesty, name: 'Frankie\'s Coffee Shop')
      create(:ada_travesty, name: 'Hipster Coffee Shop')
      create(:unisex_and_ada_travesty, name: 'Organic Co. Coffee', comment: 'Pretty tile.')
    end

    let(:json) { JSON.parse(response.body) }

    context 'when looking for unisex travesties and given a search query' do
      before do
        get '/api/v1/travesties/search', params: { query: 'Coffee', unisex: true }
      end

      it "is successful" do
        expect(response).to have_http_status(:success)
      end

      it "finds two coffeeshops with unisex travesties" do
        expect(json.length).to eq(2)
      end

      it "returns accessible travesties" do
        expect(json.select { |travesty| travesty["unisex"] }.count).to eq 2
      end

      it "does not return non-accessible travesties" do
        expect(json.reject { |travesty| travesty["unisex"] }.count).to eq 0
      end
    end

    context 'when searching for ADA accessible travesties and given a search query' do
      before do
        get '/api/v1/travesties/search', params: { query: 'Coffee', ada: true }
      end

      it "is successful" do
        expect(response).to have_http_status(:success)
      end

      it "finds two coffeeshops with accessible travesties" do
        expect(json.length).to eq(2)
      end

      it "returns accessible travesties" do
        expect(json.select { |travesty| travesty["accessible"] }.count).to eq 2
      end

      it "does not return non-accessible travesties" do
        expect(json.reject { |travesty| travesty["accessible"] }.count).to eq 0
      end
    end

    context "when looking for travesties by updated date" do
      before do
        create(:travesty, created_at: 1.day.ago)
        params = {
          updated: true,
          day: Time.current.day,
          month: Time.current.month,
          year: Time.current.year
        }
        get "/api/v1/travesties/by_date", params:
      end

      it "is successful" do
        expect(response).to have_http_status(:success)
      end

      it "finds all travesties" do
        expect(json.length).to eq(5)
      end
    end

    context "when filtering by created date" do
      before do
        create(:travesty, created_at: 1.week.ago)
        params = {
          day: Time.current.day,
          month: Time.current.month,
          year: Time.current.year
        }
        get "/api/v1/travesties/by_date", params:
      end

      it "is successful" do
        expect(response).to have_http_status(:success)
      end

      it "finds all but one of the travesties" do
        expect(json.length).to eq(4)
      end
    end
  end
end

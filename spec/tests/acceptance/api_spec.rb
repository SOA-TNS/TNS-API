# frozen_string_literal: true

require_relative '../../helpers/spec_helper_rgt'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'
require 'rack/test'

def app
  GoogleTrend::App
end

describe 'Test API routes' do
  include Rack::Test::Methods

  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_google_trend
    # DatabaseHelper.wipe_database
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Root route' do
    it 'should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      _(body['status']).must_equal 'ok'
      _(body['message']).must_include 'API v1'
    end
  end

  describe 'get stock info (data_record+risk) route' do
    it 'should be able to get stock info (data_record+risk)' do
      GoogleTrend::Service::AddStock.new.call(QUERY)
      get "/api/v1/Gtrend/#{QUERY}"
      _(last_response.status).must_equal 200

      info = JSON.parse last_response.body
      _(info.keys.sort).must_equal %w[data_record risk]
      _(info['data_record']['query']).must_equal QUERY
      _(info['data_record']['time_series']).must_equal TIME_SERIES
      _(info['risk']['query']).must_equal QUERY
    end

    it 'should be report error for an invalid stock' do
      GoogleTrend::Service::AddStock.new.call(QUERY)

      get '/api/v1/Gtrend/23'
      _(last_response.status).must_equal 404
      _(JSON.parse(last_response.body)['status']).must_include 'not'
    end
  end

  describe 'Add stock route' do
    it 'should be able to add a stock' do
      post "api/v1/Gtrend/#{QUERY}"
      _(last_response.status).must_equal 201

      stock = JSON.parse last_response.body
      _(stock['query']).must_equal QUERY
      _(stock['time_series']).must_equal TIME_SERIES
    end

    it 'should report error for invalid stock' do
      post 'api/v1/Gtrend/vnhsiufbnisubnsre'
      _(last_response.status).must_equal 404

      response = JSON.parse(last_response.body)
      _(response['message']).must_include 'not'
    end
  end

  describe 'Get stocks list' do
    it 'should successfully return stock lists' do
      get 'api/v1/Gtrend?list=ewogICJsaXN0IjpbImFwcGxlIiwiYmFuYW5hIl0KfQ=='
      _(last_response.status).must_equal 200

      response = JSON.parse(last_response.body)

      stocks = response['stocks']
      _(stocks.count).must_equal 2
      stock = stocks.first
      _(stock['query']).must_equal QUERY
    end

    it 'should return empty lists if none found' do
      get '/api/v1/Gtrend?list=ewogICJsaXN0IjpbImNhdCJdCn0='
      _(last_response.status).must_equal 200

      response = JSON.parse(last_response.body)
      stocks = response['stocks']
      _(stocks).must_be_kind_of Array
      _(stocks.count).must_equal 0
    end

    it 'should return error if not list provided' do
      get '/api/v1/Gtrend'
      _(last_response.status).must_equal 400

      response = JSON.parse(last_response.body)
      _(response['message']).must_include 'list'
    end
  end
end

# frozen_string_literal: false

require_relative 'spec_helper_rgt'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of Google Trend API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_google_trend
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save stock from Google trend to database' do
      trend = GoogleTrend::Gt::TrendMapper.new('TSLA', RGT_TOKEN).find
      rebuilt = GoogleTrend::Repository::For.entity(trend).create(trend)

      _(rebuilt.query).must_equal(trend.query)
      _(rebuilt.time_series).must_equal(trend.time_series)
    end
  end
end

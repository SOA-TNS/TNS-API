# frozen_string_literal: true

require_relative '../../../helpers/spec_helper_rgt'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

require 'ostruct'

describe 'RiskStock Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_github(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Appraise Risk of Stock' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should give the result of risk calculation for the stock' do
      # GIVEN: a valid project that exists locally and is being watched
      trend = Google::Gt::TrendMapper.new('BTC', RGT_TOKEN).find
      GoogleTrend::Repository::For.entity(trend).create(trend)

      # WHEN: we request to appraise the project
      request = 'BTC'

      appraisal = GoogleTrend::Service::RiskStock.new.call(
        watched_list: [request],
        requested: request
      ).value!

      # THEN: we should get an appraisal
      risk = appraisal[:risk]
      _(risk).must_be_kind_of GoogleTrend::Entity::MainPageEntity
      "
      _(folder.subfolders.count).must_equal 10
      _(folder.base_files.count).must_equal 2

      _(folder.base_files.first.file_path.filename).must_equal 'README.md'
      _(folder.subfolders.first.path).must_equal 'controllers'

      _(folder.subfolders.map(&:credit_share).reduce(&:+) +
        folder.base_files.map(&:credit_share).reduce(&:+))
        .must_equal(folder.credit_share)
      "
    end

    it 'SAD: should not give the result of risk calculation for the unwatched stock' do
      # GIVEN: a valid project that exists locally and is being watched
      trend = Google::Gt::TrendMapper.new('BTC', RGT_TOKEN).find
      GoogleTrend::Repository::For.entity(trend).create(trend)

      # WHEN: we request to appraise the project
      request = 'BTC'

      result = CodePraise::Service::AppraiseProject.new.call(
        watched_list: [],
        requested: request
      )

      # THEN: we should get failure
      _(result.failure?).must_equal true
    end

    it 'SAD: should not give the result of risk calculation for the non-existent stock' do
      # GIVEN: no project exists locally

      # WHEN: we request to appraise the project
      request = 'BTC'

      result = CodePraise::Service::AppraiseProject.new.call(
        watched_list: [],
        requested: request
      )

      # THEN: we should get failure
      _(result.failure?).must_equal true
    end
  end
end

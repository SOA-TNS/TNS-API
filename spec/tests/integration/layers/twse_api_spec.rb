# frozen_string_literal: true

require_relative 'twse_spec_helper'

describe 'Tests TWSE API library' do
  #   VCR.configure do |c|
  #     c.cassette_library_dir= CASSETTES_FOLDER
  #     c.hook_into:webmock
  #   end
  #   before do
  #     VCR.insert_cassette CASSETTE_FILE,
  #                         record: :new_episodes,
  #                         match_requests_on: %i[method uri headers]
  #   end
  #   after do
  #     VCR.eject_cassette
  #   end
  # VCR.use_cassette(CASSETTE_FILE) do
  stock = CodePraise::TwseApi.new.twse_single(STOCKCODE)
  rank = CodePraise::TwseApi.new.twse_rank

  describe 'Project information' do
    it 'HAPPY: should provide correct stock information' do
      _(stock.pd_op).must_equal CORRECT_i['PreviousDayOpeningRefPrice']
      _(stock.td_op).must_equal CORRECT_i['TodayOpeningRefPrice']
      _(stock.pd_ld).must_equal CORRECT_i['PreviousDayLimitDown']
      _(stock.td_ld).must_equal CORRECT_i['TodayLimitDown']
      _(stock.pd_lu).must_equal CORRECT_i['PreviousDayLimitUp']
      _(stock.td_lu).must_equal CORRECT_i['TodayLimitUp']
    end
    #       it 'SAD: should raise exception on incorrect stock information' do
    #         _(proc do
    #           CodePraise::TwseApi.new.twse_single(0000)
    #         end).must_raise CodePraise::TwseApi::Errors::NotFound
    #       end
  end

  describe 'stock rank information' do
    it 'HAPPY: should check top 5' do
      reference = CORRECT['集中市場每日成交量前二十名證券'].select { |x| x['Rank'].to_i < 6 }
      _(rank.info(5)).must_equal reference
    end
    it 'HAPPY: should check total number of ranks' do
      reference = CORRECT['集中市場每日成交量前二十名證券'].count
      _(rank.info(20).count).must_equal reference
    end
  end
  # end
end

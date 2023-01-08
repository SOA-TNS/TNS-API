# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'
require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'
require_relative '../../require_app'
require_app

def time_value(file)
  array = []
  time_series = file['interest_over_time'] # hash
  interest_over_time = interest_over_time['timeline_data'] # array
  interest_over_time.each { |data| array << "#{data['date']} => #{data['values'][0]['value']}" }
  array.to_s
end

RGT_TOKEN = GoogleTrend::App.config.RGT_TOKEN
CORRECT = YAML.safe_load(File.read('spec/fixtures/rgt_results.yml'))
CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'rgt_api'
QUERY = 'apple'
TIME_SERIES = '["Nov 28 – Dec 4, 2021 => 74", "Dec 5 – 11, 2021 => 69", "Dec 12 – 18, 2021 => 68", "Dec 19 – 25, 2021 => 75", "Dec 26, 2021 – Jan 1, 2022 => 85", "Jan 2 – 8, 2022 => 77", "Jan 9 – 15, 2022 => 70", "Jan 16 – 22, 2022 => 62", "Jan 23 – 29, 2022 => 67", "Jan 30 – Feb 5, 2022 => 66", "Feb 6 – 12, 2022 => 62", "Feb 13 – 19, 2022 => 63", "Feb 20 – 26, 2022 => 59", "Feb 27 – Mar 5, 2022 => 62", "Mar 6 – 12, 2022 => 66", "Mar 13 – 19, 2022 => 60", "Mar 20 – 26, 2022 => 63", "Mar 27 – Apr 2, 2022 => 58", "Apr 3 – 9, 2022 => 58", "Apr 10 – 16, 2022 => 57", "Apr 17 – 23, 2022 => 59", "Apr 24 – 30, 2022 => 58", "May 1 – 7, 2022 => 59", "May 8 – 14, 2022 => 59", "May 15 – 21, 2022 => 57", "May 22 – 28, 2022 => 57", "May 29 – Jun 4, 2022 => 56", "Jun 5 – 11, 2022 => 65", "Jun 12 – 18, 2022 => 59", "Jun 19 – 25, 2022 => 60", "Jun 26 – Jul 2, 2022 => 63", "Jul 3 – 9, 2022 => 59", "Jul 10 – 16, 2022 => 66", "Jul 17 – 23, 2022 => 63", "Jul 24 – 30, 2022 => 62", "Jul 31 – Aug 6, 2022 => 65", "Aug 7 – 13, 2022 => 66", "Aug 14 – 20, 2022 => 65", "Aug 21 – 27, 2022 => 66", "Aug 28 – Sep 3, 2022 => 68", "Sep 4 – 10, 2022 => 100", "Sep 11 – 17, 2022 => 80", "Sep 18 – 24, 2022 => 80", "Sep 25 – Oct 1, 2022 => 75", "Oct 2 – 8, 2022 => 77", "Oct 9 – 15, 2022 => 75", "Oct 16 – 22, 2022 => 72", "Oct 23 – 29, 2022 => 69", "Oct 30 – Nov 5, 2022 => 69", "Nov 6 – 12, 2022 => 68", "Nov 13 – 19, 2022 => 68", "Nov 20 – 26, 2022 => 76"]'

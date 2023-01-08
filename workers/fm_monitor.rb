# frozen_string_literal: true

module FmPer
  # Infrastructure to Fm while yielding progress
  module FmMonitor
    Fm_PROGRESS = {
      'STARTED'   => 15,
      'Cloning'   => 30,
      'remote'    => 70,
      'Receiving' => 85,
      'Resolving' => 95,
      'Checking'  => 100,
      'FINISHED'  => 100
    }.freeze

    def self.starting_percent
      Fm_PROGRESS['STARTED'].to_s
    end

    def self.finished_percent
      Fm_PROGRESS['FINISHED'].to_s
    end

    def self.progress(line)
      Fm_PROGRESS[first_word_of(line)].to_s
    end

    def self.percent(stage)
      Fm_PROGRESS[stage].to_s
    end

    def self.first_word_of(line)
      line.match(/^[A-Za-z]+/).to_s
    end
  end
end

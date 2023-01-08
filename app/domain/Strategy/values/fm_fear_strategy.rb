# frozen_string_literal: true

module GoogleTrend
  module Value
    class FmFearStrategy
      def initialize(fr_value)
        @fr_value = fr_value
      end

      def fear_value
        @fr_value[-1].to_s
      end

      def fr_strategy
        fr = @fr_value[-1]
        if fr > 80
          "#{fr} => greed : 持續獲利出場階段"
        elsif fr >= 50 && fr <= 80
          "#{fr} => greed : 留意市場多空結構和鯨魚動向＋準備開始減倉"
        elsif fr >= 40 && fr < 50
          "#{fr} => medium : 中性市場，繼續持有"
        elsif fr >= 20 && fr < 40
          "#{fr} => fear : 觀察市場動向 + 尋找潛在佈局時機"
        else
          "#{fr} => fear : 持續買入建倉佈局"
        end
      end
    end
  end
end

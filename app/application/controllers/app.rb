# frozen_string_literal: true

require 'roda'
require 'cgi'

module GoogleTrend
  # Web App
  class App < Roda
    plugin :halt
    plugin :caching
    plugin :all_verbs # allows DELETE and other HTTP verbs beyond GET/POST
    plugin :common_logger, $stderr

    # use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    route do |routing|
      response['Content-Type'] = 'application/json'

      # GET /
      routing.root do
        message = "Google Trend API v1 at GoogleTrend in #{App.environment} mode"

        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message:)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do
        routing.on 'Gtrend' do
          routing.on String do |qry|
            routing.post do
              input = { 'rgt_url' =>qry }
              result = Service::AddStock.new.call(input)
              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end
              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::RgtRepresenter.new(result.value!.message).to_json
            end
          end
        end
        routing.on 'Risk' do
          routing.on String do |qry|
            routing.post do
              App.configure :production do
                response.cache_control public: true, max_age: 300
              end
              result = Service::RiskStock.new.call(requested: CGI.unescape(qry))
              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::StockInfo.new(
                result.value!.message
              ).to_json
            end
          end
        end
        routing.on 'Fear' do
          routing.on String do |qry|
            routing.post do
              input = { 'rgt_url' =>GoogleTrend::Value::StockOverview.new(CGI.unescape(qry)).stock_overview }
              result = Service::FmFear.new.call(input)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              Finmind::Representer::FmFearRepresenter.new(result.value!.message).to_json
            end
          end
        end
        routing.on 'Per' do
          routing.on String do |qry|
            routing.post do
              input = { 'rgt_url' =>GoogleTrend::Value::StockOverview.new(CGI.unescape(qry)).stock_overview }
              result = Service::FmPer.new.call(input)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              Finmind::Representer::FmPerRepresenter.new(result.value!.message).to_json
            end
          end
        end
        routing.on 'Div' do
          routing.on String do |qry|
            routing.post do
              input = { 'rgt_url' =>GoogleTrend::Value::StockOverview.new(CGI.unescape(qry)).stock_overview }
              result = Service::FmDiv.new.call(input)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              Finmind::Representer::FmPerRepresenter.new(result.value!.message).to_json
            end
          end
        end
        routing.on 'News' do
          routing.on String do |qry|
            routing.get do
              input = { 'rgt_url' =>GoogleTrend::Value::StockOverview.new(CGI.unescape(qry)).stock_overview }
              result = Service::FmNews.new.call(input)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Finmind::Representer::FmNewsRepresenter.new(result.value!.message).to_json
            end
          end
        end
        routing.on 'BuySell' do
          routing.on String do |qry|
            routing.post do
              input = { 'rgt_url' =>GoogleTrend::Value::StockOverview.new(CGI.unescape(qry)).stock_overview }
              result = Service::FmBuySell.new.call(input)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Finmind::Representer::FmBslRepresenter.new(result.value!.message).to_json
            end
          end
        end
        # routing.is do
        #   # GET /projects?list={base64_json_array_of_project_fullnames}
        #   routing.get do

        #     list_req = Request::StockList.new(routing.params)
        #     result = Service::ListStocks.new.call(list_request: list_req)

        #     if result.failure?
        #       failed = Representer::HttpResponse.new(result.failure)
        #       routing.halt failed.http_status_code, failed.to_json
        #     end

        #     http_response = Representer::HttpResponse.new(result.value!)
        #     response.status = http_response.http_status_code
        #     Representer::StocksList.new(result.value!.message).to_json
        # end
      end
    end
  end
end

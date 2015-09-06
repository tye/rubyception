module Rubyception
  class LogsController < ApplicationController
    include ActionController::Live
    skip_before_filter :verify_authenticity_token

    def index
      request.session_options[:skip] = true
      response.headers['Content-Type'] = 'text/event-stream'
      while event = Rubyception::Queue.shift
        next if %w(rubyception/logs rubyception/application).include?(event.controller)
        sse = SSE.new(response.stream,event: 'rubyception')
        sse.write event.to_json
      end
    rescue IOError
    ensure
      response.stream.close
    end
  end
end

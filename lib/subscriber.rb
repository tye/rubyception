module Rubyception
  class Subscriber < ActiveSupport::LogSubscriber
    INTERNAL_PARAMS = %w(controller action format _method only_path)

    def start_processing(event)
      WebsocketServer.current_entry = Entry.new(event)
    rescue Exception => e
      Rails.logger.info "#{e.class.name}: #{e.message}"
      Rails.logger.info e.backtrace.join("\n")
    end

    def process_action(event)
      WebsocketServer.current_entry.finalize(event)
    rescue Exception => e
      Rails.logger.info "#{e.class.name}: #{e.message}"
      Rails.logger.info e.backtrace.join("\n")
    end
  end
end

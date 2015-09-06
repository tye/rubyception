module Rubyception
  class Queue
    @queue = []

    def self.add event
      @queue << event
    end

    def self.shift
      @queue.shift
    end

    def self.any?
      @queue.any?
    end
  end
end

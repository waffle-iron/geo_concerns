class GeoblacklightEventProcessor
  class Processor
    attr_reader :event
    def initialize(event)
      @event = event
    end

    def index
      RSolr.connect(Geoblacklight.config)
    end

    private

      def event_type
        event['event']
      end

      def id
        event['id']
      end

      def doc
        event['doc']
      end
  end
end

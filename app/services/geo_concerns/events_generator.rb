module GeoConcerns
  class EventsGenerator
    attr_reader :messaging_client
    def initialize(messaging_client)
      @messaging_client = messaging_client
    end

    def record_created(record)
      generators.record_created(record, messaging_client)
    end

    def record_deleted(record)
      generators.record_deleted(record, messaging_client)
    end

    def record_updated(record)
      generators.record_updated(record, messaging_client)
    end

    def derivatives_created(record)
      generators.derivatives_created(record, messaging_client)
    end

    def generators
      @generators ||= CompositeGenerator.new(
          geoblacklight_event_generator,
          geoserver_event_generator
        )
    end

    private

      def geoblacklight_event_generator
        GeoblacklightEventGenerator.new(messaging_client)
      end

      def geoserver_event_generator
        GeoserverEventGenerator.new(messaging_client)
      end
  end
end

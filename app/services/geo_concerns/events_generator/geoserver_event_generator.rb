module GeoConcerns
  class EventsGenerator
    class GeoserverEventGenerator < BaseEventsGenerator
      def derivatives_created(record, messaging_client)
        return unless record.geo_file_format?
        publish_message(
          message("CREATED", record)  
        ) 
      end

      # Message that file set has update.
      def record_updated(record, messaging_client)
        return unless record.geo_file_format?
        publish_message(
          message("UPDATED", record)
        )
      end

      def message(type, record)
        base_message(type, record).merge({
          "worker" => :geoserver,
          "shapefile_url" => display_vector_url(record)
        })
      end

      private

        def display_vector_url(record)
          helper.download_url(record, file: 'display_vector')
        end
    end
  end
end

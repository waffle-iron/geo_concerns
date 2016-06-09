module GeoConcerns
  class EventsGenerator
    class GeoblacklightEventGenerator < BaseEventsGenerator
      def record_created(record, messaging_client)
        publish_message(
          message("CREATED", record)
        )
      end

      def record_deleted(record, messaging_client)
        publish_message(
          delete_message("DELETED", record)
        )
      end

      def record_updated(record, messaging_client)
        publish_message(
          message("UPDATED", record)
        )
      end

      def message(type, record)
        base_message(type, record).merge({
          "worker" => :geoblacklight,
          "geoblacklight_url" => geoblacklight_url(record)
        })
      end

      def delete_message(type, record)
        base_message(type, record).merge({
          "worker" => :geoblacklight
        })
      end

      private

        def geoblacklight_url(record)
          helper.polymorphic_url(record) + '/geoblacklight'
        end
    end
  end
end

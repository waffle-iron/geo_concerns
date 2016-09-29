module GeoConcerns
  class EventsGenerator
    class GeoblacklightEventGenerator < BaseEventsGenerator
      def record_created(record)
        return unless (@gbl_document = generate_document(record))
        publish_message(
          message("CREATED", record)
        )
      end

      def record_deleted(record)
        return unless (@gbl_document = generate_document(record))
        publish_message(
          delete_message("DELETED", record)
        )
      end

      def record_updated(record)
        return unless (@gbl_document = generate_document(record))
        publish_message(
          message("UPDATED", record)
        )
      end

      def message(type, record)
        base_message(type, record).merge("exchange" => :geoblacklight,
                                         "doc" => @gbl_document)
      end

      def delete_message(type, record)
        base_message(type, record).merge("exchange" => :geoblacklight,
                                         "id" => @gbl_document.to_hash[:layer_slug_s])
      end

      private

        # Get the work presenter that should be converted into a geoblacklight document.
        # TODO: Find and return the parent presenter for file sets.
        def presenter(record)
          return record unless record.class == FileSetPresenter
        end

        def generate_document(record)
          return Discovery::DocumentBuilder.new(presenter(record),
                                                Discovery::GeoblacklightDocument.new)
        rescue StandardError
          return nil
        end
    end
  end
end

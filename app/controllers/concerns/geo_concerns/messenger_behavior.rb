module GeoConcerns
  module MessengerBehavior
    extend ActiveSupport::Concern

    def destroy
      super
      messenger.record_deleted(geo_concern)
    end

    def after_create_response
      super
      messenger.record_created(geo_concern)
    end

    def after_update_response
      super
      messenger.record_updated(geo_concern)
    end

    def messenger
      # @messenger ||= GeoConcerns::EventsGenerator.new(nil)
      @messenger ||= GeoConcerns::EventsGenerator.new(GeoConcerns::MessagingClient.new('amqp://127.0.0.1:5672'))
    end

    def geo_concern
      show_presenter.new(curation_concern, current_ability, request)
    end
  end
end

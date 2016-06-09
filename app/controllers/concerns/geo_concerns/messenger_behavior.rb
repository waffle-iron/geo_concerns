module GeoConcerns
  module MessengerBehavior
    extend ActiveSupport::Concern

    def destroy
      super
      messenger.record_deleted(curation_concern)
    end

    def after_create_response
      super
      messenger.record_created(curation_concern)
    end

    def after_update_response
      super
      messenger.record_updated(curation_concern)
    end

    def messenger
      @messenger ||= GeoConcerns::EventsGenerator.new(nil)
    end
  end
end

require 'bunny'

module GeoConcerns
  class MessagingClient
    attr_reader :amqp_url
    def initialize(amqp_url)
      @amqp_url = amqp_url
    end

    def publish(message)
      exchange_name = JSON.parse(message)['exchange']
      # byebug
      send(exchange_name)
      @exchange.publish(message, persistent: true)
    rescue
      Rails.logger.warn "Unable to publish message to #{amqp_url}"
    end

    private

      def bunny_client
        @bunny_client ||= Bunny.new(amqp_url).tap(&:start)
      end

      def channel
        @channel ||= bunny_client.create_channel
      end

      def geoblacklight
        @exchange ||= channel.fanout('gbl_events', durable: true)      
        # @exchange ||= channel.fanout(Plum.config['events']['exchange'], durable: true)
      end

      def geoserver
        @exchange ||= channel.fanout('geoserver_events', durable: true)      
        # @exchange ||= channel.fanout(Plum.config['events']['exchange'], durable: true)
      end
  end
end
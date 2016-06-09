module GeoConcerns
  class EventsGenerator
    class CompositeGenerator
      attr_reader :generators

      def initialize(*generators)
        @generators = generators.compact
      end

      def method_missing(m, *args, &block)
        generators.each do |generator|
          next unless generator.respond_to? m
          generator.send(m, args.first, messaging_client)
        end
      end
    end
  end
end

module GeoConcerns
  module Processors
    module Vector
      class Processor < Hydra::Derivatives::Processors::Processor
        def process
          vector_processor_class.new(source_path,
                                     directives,
                                     output_file_service: output_file_service).process
        end

        # Returns a vector processor class based on mime type passed in the directives object.
        # @return vector processing class
        def vector_processor_class
          case directives.fetch(:input_format)
          when 'application/zip; ogr-format="ESRI Shapefile"'
            GeoConcerns::Processors::Vector::Shapefile
          else
            GeoConcerns::Processors::Vector::Base
          end
        end
      end
    end
  end
end

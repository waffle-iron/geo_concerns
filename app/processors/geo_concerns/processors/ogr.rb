module GeoConcerns
  module Processors
    module Ogr
      extend ActiveSupport::Concern

      included do
        # Executes a ogr2ogr command. Used to reproject a
        # vector dataset and save the output as a shapefile
        # @param in_path [String] file input path
        # #param options [Hash] creation options
        # @param out_path [String] processor output file path
        def self.reproject(in_path, out_path, options)
          # reset the basename
          vector_info = GeoConcerns::Processors::Vector::Info.new(in_path)
          # use the id for the basename unless it isn't set
          options[:basename] = options[:id] || vector_info.name
          execute "env SHAPE_ENCODING= ogr2ogr -q -nln #{options[:basename]} -f 'ESRI Shapefile'"\
                    " -t_srs #{options[:output_srid]} -preserve_fid '#{out_path}' '#{in_path}'"
        end
      end
    end
  end
end

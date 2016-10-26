module GeoConcerns
  module Processors
    class GeoProcessor < Hydra::Derivatives::Processors::Processor
      include Hydra::Derivatives::Processors::ShellBasedProcessor

      # Chains together and recursively runs a set of commands.
      # Except for the last command in the queue, a temp file
      # is created as output and is then fed into the input of the next.
      # Temp files are deleted in reverse order after the last command
      # is run. The commands must have the same method signature:
      # command_name(in_path, out_path, options)
      #
      # @param in_path [String] file input path
      # @param out_path [String] processor output file path
      # @param method_queue [Array] set of commands to run
      # @param options [Hash] creation options to pass
      def self.run_commands(in_path, out_path, method_queue, options)
        next_step = method_queue.shift
        if method_queue.empty?
          method(next_step).call(in_path, out_path, options)
        else
          temp = temp_path(out_path)
          method(next_step).call(in_path, temp, options)
          run_commands(temp, out_path, method_queue, options)
          FileUtils.rm_rf(temp)
        end
      end

      # Returns a path to an intermediate temp file or directory.
      # @param path [String] input file path to base temp path on
      # @return [String] tempfile path
      def self.temp_path(path)
        time = (Time.now.to_f * 1000).to_i
        "#{File.dirname(path)}/#{File.basename(path, File.extname(path))}_#{time}"
      end

      def options_for(_format)
        {
          label: label,
          output_size: output_size,
          output_srid: output_srid,
          basename: basename
        }
      end

      # Returns the label directive or an empty string.
      # @return [Sting] output label
      def label
        directives.fetch(:label, '')
      end

      # Transforms the size directive into a GDAL size parameter.
      # @return [String] derivative size
      def output_size
        return unless directives[:size]
        directives[:size].tr('x', ' ')
      end

      # Gets srid for reprojection derivative or returns WGS 84.
      # @return [String] spatial reference code
      def output_srid
        directives.fetch(:srid, 'EPSG:4326')
      end

      # Extracts the base file name (without extension) from the source file path.
      # @return [String] base file name for source
      def basename
        File.basename(source_path, File.extname(source_path))
      end
    end
  end
end

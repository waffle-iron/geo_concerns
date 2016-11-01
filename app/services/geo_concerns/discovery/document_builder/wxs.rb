module GeoConcerns
  module Discovery
    class DocumentBuilder
      class Wxs
        attr_reader :geo_concern
        def initialize(geo_concern)
          @geo_concern = geo_concern
          @config = fetch_config
        end

        # Returns the identifier to use with WMS/WFS/WCS services.
        # @return [String] wxs indentifier
        def identifier
          return unless geo_file_set?
          return file_set.id unless @config && visibility
          "#{@config[:workspace]}:#{file_set.id}" if @config[:workspace]
        end

        # Returns the wms server url.
        # @return [String] wms server url
        def wms_path
          return unless @config && visibility && geo_file_set?
          "#{path}/#{@config[:workspace]}/wms"
        end

        # Returns the wfs server url.
        # @return [String] wfs server url
        def wfs_path
          return unless @config && visibility && geo_file_set?
          "#{path}/#{@config[:workspace]}/wfs"
        end

        private

          # Fetch the geoserver configuration.
          # @return [Hash] geoserver configuration
          def fetch_config
            data = ERB.new(File.read(Rails.root.join('config', 'geoserver.yml'))).result
            YAML.load(data)['geoserver'][visibility].with_indifferent_access if visibility
          end

          # Gets the representative file set.
          # @return [FileSet] representative file set
          def file_set
            @file_set ||= begin
              representative_id = geo_concern.solr_document.representative_id
              file_set_id = [representative_id]
              file_set = geo_concern.member_presenters(file_set_id).first
            end
          end

          # Tests if the file set is a geo file set.
          # @return [Bool]
          def geo_file_set?
            return false unless file_set
            @file_set_ids ||= geo_concern.geo_file_set_presenters.map(&:id)
            @file_set_ids.include? file_set.id
          end

          # Returns the file set visibility if it's open and authenticated.
          # @return [String] file set visibility
          def visibility
            return unless file_set
            visibility = file_set.solr_document.visibility
            return visibility if visibility == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
            return visibility if visibility == 'authenticated'
          end

          # Geoserver base url.
          # @return [String] geoserver base url
          def path
            @config[:access_url]
          end
      end
    end
  end
end

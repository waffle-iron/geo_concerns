# Attributes and methods for vector metadata files
module ExternalMetadataFileBehavior
  extend ActiveSupport::Concern
  include ::Iso19139Helper
  include ::FgdcHelper
  include ::ModsHelper

  included do
    # Specifies the metadata standard to which the metadata file conforms
    # @see http://dublincore.org/documents/dcmi-terms/#terms-conformsTo
    property :conforms_to, predicate: ::RDF::Vocab::DC.conformsTo, multiple: false do |index|
      index.as :stored_searchable, :facetable
    end
  end

  # Extracts properties from the constitutent external metadata file
  # @return [Hash]
  def extract_metadata
    fn = "extract_#{geo_file_format.downcase}_metadata"
    if respond_to?(fn.to_sym)
      send(fn, metadata_xml)
    else
      fail "Unsupported metadata standard: #{geo_file_format}"
    end
  end

  # Retrives data from PCDM::File
  def metadata_xml
    Nokogiri::XML(original_file.content)
  end
end
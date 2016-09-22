module GeoConcerns
  class EventsGenerator
    class GeoblacklightEventGenerator < BaseEventsGenerator
      def record_created(record, messaging_client)
        # byebug
        publish_message(
          message("CREATED", record)
        )
      end

      def record_deleted(record, messaging_client)
        publish_message(
          delete_message("DELETED", record)
        )
      end

      def record_updated(record, messaging_client)
        publish_message(
          message("UPDATED", record)
        )
      end

      def message(type, record)
        base_message(type, record).merge({
          "exchange" => :geoblacklight,
          "doc" => generate_document(record)
          # "geoblacklight_url" => geoblacklight_url(record)
        })
      end

      def delete_message(type, record)
        base_message(type, record).merge({
          "exchange" => :geoserver
        })
      end

      private

        def generate_document(record)
          {"uuid": "me"}
          # %Q({
          #   "uuid": "http://purl.stanford.edu/dp018hs9766",
          #   "dc_identifier_s": "http://purl.stanford.edu/dp018hs9766",
          #   "dc_title_s": "1-Meter Shaded Relief Multibeam Bathymetry Image (Color): Elkhorn Slough, California, 2005",
          #   "dc_description_s": "This layer is a 10-color shaded relief GeoTIFF that contains high-resolution bathymetric data collected from the Elkhorn Slough region of Monterey Bay, California. The survey for Elkhorn Slough was conducted 8/12/2005 - 8/15/2005. Elkhorn Slough, one of the largest remaining coastal wetlands in California, has been directly subjected to tidal scour since the opening of Moss Landing Harbor in 1946. This erosion endangers the habitat of several rare and endangered species and disrupts the wetland ecosystem as a whole. In 2003, the Seafloor Mapping Lab of California State University, Monterey Bay created the most detailed bathymetry model of the Slough to date using a combination of multi-beam sonar, single-beam sonar and aerial photography. This layer was created as part of the California Seafloor Mapping Project.This project was conducted to determine changes in the pattern of erosion and deposition in Elkhorn Slough since surveys conducted in 1993, 2001 and 2003. Marine data offered here represent the efforts of a comprehensive state waters mapping program for California launched by the California State Coastal Conservancy, Ocean Protection Council, Department of Fish and Game, and the NOAA National Marine Sanctuary Program. The ultimate goal is the creation of a high-resolution 1:24,000 scale geologic and habitat base map series covering all of California's 14,500 km2 state waters out to the 3 mile limit, and support of the state's Marine Life Protection Act Initiative (MLPA) goal to create a statewide network of Marine Protected Areas (MPAs). This statewide project requires, involves and leverages expertise from industry, resource management agencies and academia. The tiered mapping campaign involves the use of state-of-the-art sonar, LIDAR (aerial laser) and video seafloor mapping technologies; computer aided classification and visualization; expert geologic and habitat interpretations codified into strip maps spanning California's land/sea boundary; and the creation of an online, publicly accessible data repository for the dissemination of all mapping products.\n",
          #   "dc_rights_s": "Restricted",
          #   "dct_provenance_s": "Stanford",
          #   "dct_references_s": "{\"http://schema.org/url\":\"http://purl.stanford.edu/dp018hs9766\",\"http://schema.org/downloadUrl\":\"http://stacks.stanford.edu/file/druid:dp018hs9766/data.zip\",\"http://www.loc.gov/mods/v3\":\"http://purl.stanford.edu/dp018hs9766.mods\",\"http://www.isotc211.org/schemas/2005/gmd/\":\"https://raw.githubusercontent.com/OpenGeoMetadata/edu.stanford.purl/master/dp/018/hs/9766/iso19139.xml\",\"http://www.w3.org/1999/xhtml\":\"http://opengeometadata.stanford.edu/metadata/edu.stanford.purl/druid:dp018hs9766/default.html\",\"http://www.opengis.net/def/serviceType/ogc/wcs\":\"http://kurma-podd1.stanford.edu/geoserver/wcs\",\"http://www.opengis.net/def/serviceType/ogc/wms\":\"http://kurma-podd1.stanford.edu/geoserver/wms\"}",
          #   "layer_id_s": "druid:dp018hs9766",
          #   "layer_slug_s": "stanford-dp018hs9766",
          #   "layer_geom_type_s": "Raster",
          #   "layer_modified_dt": "2014-12-03T02:15:20Z",
          #   "dc_format_s": "GeoTIFF",
          #   "dc_language_s": "English",
          #   "dc_type_s": "Dataset",
          #   "dc_publisher_s": "Seafloor Mapping Lab",
          #   "dc_creator_sm": [
          #     "Seafloor Mapping Lab"
          #   ],
          #   "dc_subject_sm": [
          #     "Continental margins",
          #     "Multibeam mapping",
          #     "Elevation",
          #     "Imagery and Base Maps",
          #     "Inland Waters"
          #   ],
          #   "dct_issued_s": "2006",
          #   "dct_temporal_sm": [
          #     "2005"
          #   ],
          #   "dct_spatial_sm": [
          #     "Elkhorn Slough (Calif.)",
          #     "Monterey Bay (Calif.)"
          #   ],
          #   "dc_relation_sm": [
          #     "http://sws.geonames.org/5346182/about.rdf",
          #     "http://sws.geonames.org/5374363/about.rdf"
          #   ],
          #   "georss_box_s": "36.8085911 -121.7948738 36.8606925 -121.7389503",
          #   "georss_polygon_s": "36.8085911 -121.7948738 36.8606925 -121.7948738 36.8606925 -121.7389503 36.8085911 -121.7389503 36.8085911 -121.7948738",
          #   "solr_geom": "ENVELOPE(-121.7948738, -121.7389503, 36.8606925, 36.8085911)",
          #   "solr_year_i": 2005
          # })
          # Discovery::DocumentBuilder.new(record, Discovery::GeoblacklightDocument.new)
        end

        # def geoblacklight_url(record)
        #   helper.polymorphic_url(record) + '/geoblacklight'
        # end
    end
  end
end

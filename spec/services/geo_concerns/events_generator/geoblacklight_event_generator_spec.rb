require 'spec_helper'

RSpec.describe GeoConcerns::EventsGenerator::GeoblacklightEventGenerator do
  subject { described_class.new(rabbit_connection) }
  let(:rabbit_connection) { instance_double(GeoConcerns::RabbitMessagingClient, publish: true) }
  let(:geo_concern) { FactoryGirl.build(:public_vector_work, attributes) }
  let(:record) { GeoConcerns::VectorWorkShowPresenter.new(SolrDocument.new(geo_concern.to_solr), nil) }
  let(:coverage) { GeoConcerns::Coverage.new(43, -69, 42, -71) }
  let(:title) { ['Geo Work'] }
  let(:attributes) { { id: 'geo-work-1',
                       title: ['Geo Work'],
                       coverage: coverage.to_s,
                       description: ['geo work'],
                       temporal: ['2011'] }
  }
  let(:title) { ['Geo Work'] }
  let(:refs) { { "http://schema.org/url" => "http://localhost:3000/concern/vector_works/geo-work-1" } }
  let(:discovery_doc) { { "geoblacklight_version" => "1.0",
                          "dc_identifier_s" => "https://your-institution/geo-work-1",
                          "layer_slug_s" => "your-institution-geo-work-1",
                          "uuid" => "your-institution-geo-work-1",
                          "dc_title_s" => title.first,
                          "solr_geom" => "ENVELOPE(-71.0, -69.0, 43.0, 42.0)",
                          "dct_provenance_s" => "Your Institution",
                          "dc_rights_s" => "Restricted",
                          "dc_description_s" => "geo work",
                          "dct_temporal_sm" => ["2011"],
                          "solr_year_i" => 2011,
                          "layer_modified_dt" => record.solr_document[:system_modified_dtsi],
                          "layer_id_s" => "geo-work-1",
                          "dct_references_s" => refs.to_json,
                          "layer_geom_type_s" => "Mixed" }
  }

  describe "#record_created" do
    it "publishes a persistent JSON message" do
      geo_concern.save
      expected_result = {
        "id" => record.id,
        "event" => "CREATED",
        "exchange" => "geoblacklight",
        "doc" => discovery_doc
      }

      subject.record_created(record)
      expect(rabbit_connection).to have_received(:publish).with(expected_result.to_json)
    end
  end

  describe "#record_deleted" do
    it "publishes a persistent JSON message" do
      geo_concern.save
      geo_concern.destroy
      expected_result = {
        "id" => "your-institution-geo-work-1",
        "event" => "DELETED",
        "exchange" => "geoblacklight"
      }

      subject.record_deleted(record)
      expect(rabbit_connection).to have_received(:publish).with(expected_result.to_json)
    end
  end

  describe "#record_updated" do
    let(:title) { ['New Geo Work'] }
    it "publishes a persistent JSON message with collection memberships" do
      geo_concern.title = ["New Geo Work"]
      geo_concern.save!
      expected_result = {
        "id" => record.id,
        "event" => "UPDATED",
        "exchange" => "geoblacklight",
        "doc" => discovery_doc
      }

      subject.record_updated(record)
      expect(rabbit_connection).to have_received(:publish).with(expected_result.to_json)
    end
  end
end

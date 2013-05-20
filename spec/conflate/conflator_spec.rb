require "spec_helper"
require "conflate/conflator"

module Conflate
  describe Conflator do
    let(:config) { stub(:rails_config) } # e.g., Rails.application.config
    let(:path) { File.expand_path File.join(__FILE__, "../../support/configs/") }

    subject { Conflator.new path, config }

    context "#perform" do

      it "should parse only the yml files in the config path" do
        # yaml files
        subject.should_receive(:apply_config).with(File.expand_path(File.join path, "foo.yml"))
        # but not other files
        subject.should_not_receive(:apply_config).with(File.expand_path(File.join path, "ignore.txt"))
        subject.perform
      end

    end

    context "#apply_config filename" do

      let(:hash) { {foo: "bar", bing: "bang" } }
      let(:yaml) { "some_file.yml" }

      it "parses the given path and applies its keys and values to the config object" do
        subject.should_receive(:parse_config).with(yaml) { hash }
        config.should_receive("some_file=").with hash
        subject.send(:apply_config, yaml)
      end

    end

    context "#parse_config filename" do

      let(:base) { File.expand_path File.join(__FILE__, "../../support/specific_examples") }
      let(:basic_hash) { File.join base, "hash.yml" }
      let(:invalid) { File.join base, "invalid.yml" }
      let(:missing) { File.join base, "missing.yml" }
      let(:erb) { File.join base, "erb.yml" }

      it "reads a hash from the YAML file" do
        expect(subject.send(:parse_config, basic_hash)).to eq({"foo" => "bar"})
      end

      it "gracefully handles invalid YAML" do
        expect(subject.send(:parse_config, invalid)).to eq({})
      end

      it "gracefully handles a missing file" do
        expect(subject.send(:parse_config, missing)).to eq({})
      end

      it "parses ERB in the YAML file" do
        expect(subject.send(:parse_config, erb)).to eq({"foo" => "BAR"})
      end

    end
  end
end

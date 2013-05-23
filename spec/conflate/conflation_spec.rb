require "spec_helper"
require "conflate/conflation"

module Conflate
  describe Conflation do

    let(:yaml_path) { "config/something.yml" }
    let(:config_object) { stub(:config) }

    subject { Conflation.new yaml_path, config_object }

    context ".new(yaml_path, config_object)" do

      it "remembers the YAML path and config object given to it" do
        expect(subject.yaml_path).to eq yaml_path
        expect(subject.config_object).to eq config_object
      end

    end

    context "#apply" do

      before do
        subject.stub({
          name: "something",
          data: {foo: "bar"},
        })
      end

      it "applies the values in the YAML file if the config object does not have an attribute of that name" do
        # bare stub object, so has no attributes, certainly not `subject.name`
        config_object.should_receive("#{subject.name}=").with(subject.send(:data))
        subject.apply
      end

      it "applies the values in the YAML file to the config object if it has the attribute but the value is nil" do
        config_object.stub(subject.name) { nil }
        config_object.should_receive("#{subject.name}=").with(subject.send(:data))
        subject.apply
      end

      it "does not apply the value if the config object already has a value at that key" do
        config_object.stub(subject.name) { stub(:existing_data) }
        config_object.should_not_receive("#{subject.name}=")
        subject.should_receive(:warn)
        subject.apply
      end

    end

    context "#name" do

      it "parses from the YAML filename" do
        expect(subject.name).to eq "something"
      end

    end

    context "#data" do

      let(:base) { File.expand_path File.join(__FILE__, "../../support/specific_examples") }
      let(:basic_hash) { File.join base, "hash.yml" }
      let(:invalid) { File.join base, "invalid.yml" }
      let(:missing) { File.join base, "missing.yml" }
      let(:erb) { File.join base, "erb.yml" }

      it "reads a hash from the YAML file" do
        subject.yaml_path = basic_hash
        expect(subject.send(:data)).to eq({"foo" => "bar"})
      end

      it "gracefully handles invalid YAML" do
        subject.yaml_path = invalid
        expect(subject.send(:data)).to eq({})
      end

      it "gracefully handles a missing file" do
        subject.yaml_path = missing
        expect(subject.send(:data)).to eq({})
      end

      it "parses ERB in the YAML file" do
        subject.yaml_path = erb
        expect(subject.send(:data)).to eq({"foo" => "BAR"})
      end

    end
  end
end

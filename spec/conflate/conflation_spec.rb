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
  end
end

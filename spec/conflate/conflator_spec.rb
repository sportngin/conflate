require "spec_helper"
require "conflate/conflator"

module Conflate
  describe Conflator do
    let(:config) { stub(:rails_config) } # e.g., Rails.application.config
    let(:path) { File.expand_path File.join(__FILE__, "../../support/configs/") }

    subject { Conflator.new path, config }

    context "#perform" do

      let(:yaml_conflation) { stub(:conflation) }

      it "should parse only the yml files in the config path" do
        # yaml files
        Conflation.should_receive(:new).with(File.expand_path(File.join path, "foo.yml"), config) { yaml_conflation }
        yaml_conflation.should_receive(:apply)
        # but not other files
        Conflation.should_not_receive(:new).with(File.expand_path(File.join path, "ignore.txt"))
        subject.perform
      end

    end

  end
end

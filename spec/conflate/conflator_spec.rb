require "spec_helper"
require "conflate/conflator"

module Conflate
  describe Conflator do
    let(:config) { stub(:rails_config) } # e.g., Rails.application.config
    let(:path) { File.expand_path File.join(__FILE__, "../../support/configs/") }

    subject { Conflator.new path, config }

    context "#perform" do

      let(:yaml_conflation) { stub(:conflation) }
      let(:file_path) { File.join path, "foo.yml" }

      before do
        # subject.stub(:file_paths) { [file_path] }
      end

      it "should parse only the yml files in the config path" do

        # yaml files
        Conflation.should_receive(:new).with(File.expand_path(File.join path, "foo.yml"), config) { yaml_conflation }
        yaml_conflation.should_receive(:apply)
        # but not other files
        Conflation.should_not_receive(:new).with(File.expand_path(File.join path, "ignore.txt"))
        subject.perform
      end

    end

    context "#config_paths" do
      # these are files in spec/support/configs and read from disk for real
      let(:yml_path) { File.join path, "foo.yml" }
      let(:txt_path) { File.join path, "ignore.txt" }

      it "looks for .yml files" do
        expect(subject.send :config_paths).to include(yml_path)
      end

      it "ignores other files" do
        expect(subject.send :config_paths).to_not include(txt_path)
      end
    end

  end
end

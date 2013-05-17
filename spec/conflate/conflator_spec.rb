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
        subject.should_receive(:parse_config).with(File.expand_path(File.join path, "foo.yml"))
        subject.should_receive(:parse_config).with(File.expand_path(File.join path, "bar.yaml"))
        # but not other files
        subject.should_not_receive(:parse_config).with(File.expand_path(File.join path, "ignore.txt"))
        subject.perform
      end
    end
  end
end

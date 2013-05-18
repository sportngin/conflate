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
        subject.should_receive(:apply_config).with(File.expand_path(File.join path, "bar.yaml"))
        # but not other files
        subject.should_not_receive(:apply_config).with(File.expand_path(File.join path, "ignore.txt"))
        subject.perform
      end

    end

    context "#apply_config filename" do

      let(:hash) { {foo: "bar", bing: "bang" } }
      let(:path) { "some_file.yml" }

      it "parses the given path and applies its keys and values to the config object" do
        subject.should_receive(:parse_config).with(path) { hash }
        config.should_receive(:foo=).with("bar")
        config.should_receive(:bing=).with("bang")
        subject.send(:apply_config, path)
      end

    end

    context "#parse_config filename" do

      let(:hash) { {foo: "bar"} }
      let(:path) { "some_file.yml" }

      it "reads a hash from the YAML file" do
        YAML.should_receive(:load_file).with(path) { hash }
        expect(subject.send(:parse_config, path)).to eq hash
      end

      it "gracefully handles a missing file" do
        YAML.should_receive(:load_file).and_raise(Errno::ENOENT)
        expect(subject.send(:parse_config, path)).to eq Hash.new
      end

      it "gracefully handles invalid YAML" do
        YAML.should_receive(:load_file).and_raise(SyntaxError)
        expect(subject.send(:parse_config, path)).to eq Hash.new
      end

    end
  end
end

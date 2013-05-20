require "conflate/conflation"

# Scans for YAML files in the config directory and parses them for
# configuration values. For example, imagine the file below:
#
#     # foo.yml
#     thing1: "qwerty"
#     thing2: "asdf"
#
# It will add foo.thing1 and foo.thing2 to Rails.application.config with the
# values from foo.yml
module Conflate
  class Conflator
    attr_accessor :path, :config

    # Public: Initialize a new Conflator
    #
    # path - Path the directory containing YAML configs (e.g., Rails.root.join("config"))
    # config - Object to receive the config entries (e.g., Rails.application.config)
    def initialize(path, config)
      self.path = path
      self.config = config
    end

    # Public: Process the configuration
    def perform
      config_paths.each do |filename|
        Conflation.new(filename, config).apply
      end
    end

    # Private: The config files in the given path
    #
    # Returns an Array of Strings containing paths
    def config_paths
      Dir.glob(File.join path, "*.yml")
    end
    private :config_paths
  end
end

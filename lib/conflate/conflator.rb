require "yaml"

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
      Dir.glob(File.join path, "*.{yml,yaml}") do |filename|
        apply_config filename
      end
    end

    # Private: Apply config entries from the given YAML file
    #
    # path - Path the directory containing YAML configs (e.g., Rails.root.join("config"))
    def apply_config(yaml_path)
      # 'config/foo.yml' to 'foo'
      namespace = File.basename(yaml_path, ".yml")
      config.public_send("#{namespace}=", parse_config(yaml_path))
    end
    private :apply_config

    # Private: Parse the given YAML file, handling any problems
    #
    # Returns the object stored in the YAML file, presumed to be a Hash
    #
    # path - Path the directory containing YAML configs (e.g., Rails.root.join("config"))
    def parse_config(yaml_path)
      YAML.load_file yaml_path
    rescue StandardError, SyntaxError => e
      {}
    end
    private :parse_config
  end
end

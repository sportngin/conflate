# This class wraps around the YAML files and performs the parsing/applying of
# the config values read from them.
module Conflate
  class Conflation
    attr_accessor :yaml_path, :config_object

    # Public: Initialize a new Conflation
    #
    # yaml_path - Path to the YAML file to read config information from
    # config_object - Object to receive the configuration values (e.g., Rails.application.config)
    def initialize(yaml_path, config_object)
      self.yaml_path = yaml_path
      self.config_object = config_object
    end
  end
end

require "yaml"

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

    # Public: Add the contents of the YAML file to the config object
    def apply
      if config_object.respond_to?(name) && !config_object.public_send(name).nil?
        # doing this to properly handle the slightly different behaviors of
        # OpenStruct (which does respond to unassigned attributes) or the
        # Rails.application.config object (which doesn't)
        warn "#{name} already contains some information, so skipping conflating it with the contents of #{yaml_path}"
        return # so don't set it
      end

      config_object.public_send "#{name}=", data
    end

    # Public: The name of the conflation, based on the YAML file name
    #
    # Returns a String
    def name
      File.basename(yaml_path, ".yml")
    end

    # Private: The parsed data from the YAML file
    def data
      YAML.load ERB.new(File.read File.expand_path yaml_path).result
    rescue StandardError, SyntaxError => e
      {}
    end
    private :data

  end
end

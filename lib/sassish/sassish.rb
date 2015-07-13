require "sass/rails"
require "rails/generators"
require "rails/generators/sass/assets/assets_generator"
require "rails/generators/scss/assets/assets_generator"
# Monkey Patch Files (generators)
require File.expand_path(File.join('..', 'extensions', 'generators', 'sass', 'assets', 'assets_generator'), __FILE__)
require File.expand_path(File.join('..', 'extensions', 'generators', 'scss', 'assets', 'assets_generator'), __FILE__)
# Sassish generator
require File.expand_path(File.join('..', '..', 'generators', 'rails', 'precompiled_stylesheet_generator'), __FILE__)
# Helper
require File.expand_path(File.join('..', 'view_helper'), __FILE__)
# Engine
require File.expand_path(File.join('..', 'engine'), __FILE__)

# This module adapts almost all the generators associated with the stylesheet organization approach
# described on the Readme file.
module Sassish

  # relative root for the stylesheets, it will be used for configuring the
  # location for the sass template (rails generator)
  mattr_accessor :relative_root_for_stylesheets

  # Sets the new stylesheet location app/assets/stylesheets/<location>
  mattr_accessor :stylesheet_directory_path

  # pure relative path to new style folder
  mattr_accessor :relative_stylesheet_directory_path

  #
  # Defines a new stylesheet folder location and starts the monkey patching for the stylesheet generators
  #
  # @param [String] relative_stylesheet_path
  #
  def self.define_stylesheet_path(relative_stylesheet_path)
    relative_root_for_stylesheets = 'app/assets/stylesheets'
    relative_stylesheet_directory_path = relative_stylesheet_path
    stylesheet_directory_path = File.join(relative_root_for_stylesheets, relative_stylesheet_path)
    modify_stylesheet_generators
    clear_sassish_cache
  end

  #
  # Apply monkey patching on the sass stylesheet generators
  #
  def self.modify_stylesheet_generators
    Sass::Generators::AssetsGenerator.__send__ :include, Sassish::Extensions::Generators::Sass::Assets::AssetsGenerator
    Scss::Generators::AssetsGenerator.__send__ :include, Sassish::Extensions::Generators::Scss::Assets::AssetsGenerator
  end

  #
  # Clears the cached sassish for avoiding posible conflicts
  #
  def self.clear_sassish_cache
    Rails.cache.fetch("sassish").try(:clear)
    Rails.cache.fetch("sassish") { {} }
  end

  # defines wrapped accessor to Sassish configurator
  def self.setup
    yield self
  end
end

require_relative "trestle/version"

require "active_support/all"
require "kaminari"

# A modern, responsive admin framework for Ruby on Rails.
module Trestle
  require_relative "trestle/evaluation_context"
  require_relative "trestle/builder"
  require_relative "trestle/hook"
  require_relative "trestle/toolbar"
  require_relative "trestle/adapters"
  require_relative "trestle/attribute"
  require_relative "trestle/breadcrumb"
  require_relative "trestle/configurable"
  require_relative "trestle/configuration"
  require_relative "trestle/display"
  require_relative "trestle/form"
  require_relative "trestle/model_name"
  require_relative "trestle/navigation"
  require_relative "trestle/options"
  require_relative "trestle/reloader"
  require_relative "trestle/scopes"
  require_relative "trestle/tab"
  require_relative "trestle/table"
  require_relative "trestle/admin"
  require_relative "trestle/resource"

  # @!attribute admins [rw]
  #   @return [Hash{String => Admin}]
  mattr_accessor(:admins)

  # @!attribute admins [rw]
  #   @return [Hash{String => Admin}]
  self.admins = {}

  # @param name [Symbol]
  # @param options [Hash]
  # @param &block [Proc]
  #
  # @return [void]
  def self.admin(name, options={}, &block)
    register(Admin::Builder.create(name, options, &block))
  end

  # @param name [Symbol]
  # @param options [Hash]
  # @param &block [Proc]
  #
  # @return [void]
  #
  # @yieldself [Trestle::Resource::Builder]
  def self.resource(name, options={}, &block)
    register(Resource::Builder.create(name, options, &block))
  end

  # @param admin [Trestle::Admin]
  #
  # @return [void]
  def self.register(admin)
    self.admins[admin.admin_name] = admin
  end

  # @param admin [Trestle::Admin]
  #
  # @return [void]
  def self.lookup(admin)
    return admin if admin.is_a?(Class) && admin < Trestle::Admin

    self.admins[admin.to_s]
  end

  # @return [Trestle::Configuration]
  def self.config
    @configuration ||= Configuration.new
  end

  # @param &block [Proc]
  #
  # @return [void]
  def self.configure(&block)
    config.configure(&block)
  end

  # @param context [Doc::Unknown]
  #
  # @return [Trestle::Navigation]
  def self.navigation(context)
    blocks = config.menus + admins.values.map(&:menu).compact
    Navigation.build(blocks, context)
  end

  # @param locale [String,Symbol]
  #
  # @return [Symbol]
  def self.i18n_fallbacks(locale=I18n.locale)
    if I18n.respond_to?(:fallbacks)
      I18n.fallbacks[locale]
    elsif locale.to_s.include?("-")
      fallback = locale.to_s.split("-").first
      [locale, fallback]
    else
      [locale]
    end
  end
end

require_relative "trestle/engine" if defined?(Rails)

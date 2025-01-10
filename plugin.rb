# frozen_string_literal: true

# name: custom_sso
# about: Custom SSO
# version: 0.1
# authors: Ahsan

enabled_site_setting :enable_custom_sso

after_initialize do
  module ::CustomSso
    PLUGIN_NAME = "custom_sso_user".freeze

    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace CustomSso
    end
  end

  require_relative "app/controllers/custom_sso_controller"

  CustomSso::Engine.routes.draw do
    post "/create" => "custom_sso#create", :constraints => {format: /(json|rss)/,}
  end

  Discourse::Application.routes.append { mount ::CustomSso::Engine, at: "/custom_sso" }

end

# frozen_string_literal: true

# name: custom_sso_user
# about: Custom SSO user
# version: 0.1
# authors: Ahsan

enabled_site_setting :enable_custom_sso_user

after_initialize do
  module ::CustomSsoUser
    PLUGIN_NAME = "custom_sso_user".freeze

    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace CustomSsoUser
    end
  end

  require_relative "app/controllers/custom_sso_controller"

  CustomSsoUser::Engine.routes.draw do
    post "/create" => "custom_sso#create", :constraints => {format: /(json|rss)/,}
  end

  Discourse::Application.routes.append { mount ::CustomSsoUser::Engine, at: "/custom_sso" }

end

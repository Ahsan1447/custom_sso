# frozen_string_literal: true

class CustomSsoUser::CustomSsoController < ::ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  requires_plugin CustomSsoUser::PLUGIN_NAME

  def create
    user = create_user(params)

    if user && create_single_sign_on(user)
      render json: { success: true }
    else
      render json: { success: false, error: "Failed to create user or SSO record" }, status: :unprocessable_entity
    end
  end

  private

  def create_user(params)
    user = User.create!(
      username: params[:username],
      email: params[:email],
      password: "Password@789"
    )

    return user if user.activate

    nil
  end

  def create_single_sign_on(params, user)
    SingleSignOnRecord.create(
      user_id: user.id,
      external_id: params[:external_id],
      external_username: params[:username],
      external_email: params[:email],
      last_payload: {}
    )
  rescue ActiveRecord::RecordInvalid
    false
  end

end

class ApplicationController < ActionController::API
  include ActionController::Helpers

  # OAuth2 authentication methods
  def doorkeeper_authorize!(*scopes)
    unless valid_doorkeeper_token?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def valid_doorkeeper_token?
    doorkeeper_token && doorkeeper_token.acceptable?(scopes_for_request)
  end

  def doorkeeper_token
    @doorkeeper_token ||= Doorkeeper::OAuth::Token.authenticate(
      request,
      *Doorkeeper.configuration.access_token_methods
    )
  end

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  private

  def scopes_for_request
    []
  end

  # Error handling
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: 'Record not found' }, status: :not_found
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render json: { error: "Missing parameter: #{exception.param}" }, status: :bad_request
  end
end

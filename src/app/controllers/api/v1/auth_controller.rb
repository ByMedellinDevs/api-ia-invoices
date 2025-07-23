module Api
  module V1
    class AuthController < ApplicationController
      def token
        # This endpoint can be used to get access tokens using password grant
        # The actual token generation is handled by Doorkeeper
        render json: { 
          message: 'Use POST /oauth/token with grant_type=password, username, password, client_id, client_secret' 
        }
      end

      def me
        doorkeeper_authorize!
        render json: {
          id: current_resource_owner.id,
          email: current_resource_owner.email,
          name: current_resource_owner.name
        }
      end
    end
  end
end
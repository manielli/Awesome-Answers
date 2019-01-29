class Api::ApplicationController < ApplicationController
    skip_before_action(:verify_authenticity_token)
    # When making POST, DELETE, PATCH requests to our controllers
    # Rails requires that authenticity token is included as part
    # of the params.
    # Normally Rails will add this to any form that we generate.
    # i.e. form helper methods such as form_with, form_tag, form_for etc.
  
    # This prevents third parties from making such requests to our Rails
    # application. It's a security measure that is unneccessary for a Web
    # API.

    private
    def authenticate_user!
        unless current_user.present?
            render json: {status: 401}, status: 401
        end
    end
end

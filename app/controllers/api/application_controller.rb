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

    # The priority for "rescue_from" is in the reverse order of
    # where the calls are made meaning that more specific errors
    # should be rescued last and general errors should rescued first.

    # The "StandardError" class is an ancestor of all errors that
    # programmer could cause in their program. Rescuing from it
    # will prevent nearly all errors from crashing our program.
    # Use this very carefully and make sure to always log the error
    # message is some form.
    rescue_from StandardError, with: :standard_error
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid


    def not_found
        render(
            status: 404,
            json: {
                status: 404,
                errors: [{
                    type: "NotFound",
                    message: "No Route matches path /#{params[:unmatched]}"
                }]
            }
        )
    end

    
    private
    def authenticate_user!
        unless current_user.present?
            render json: {status: 401}, status: 401
        end
    end

    def record_not_found(error)
        # binding.pry
        # error.message
        # error.id
        # error.class
        # error.class.to_s
        # error.full_message
        render(
            status: 404,
            json: {
                status: 404,
                errors: [{
                    type: error.class.to_s,
                    message: error.message
                }]
            }
        )
    end

    def standard_error(error)
    # When we rescue an error, we prevent our program from
    # doing what it would normally do in a crash such as logging
    # the details and the backtrace. It's important to always
    # log this information when rescue for a general error type.

    # Use the `logger.error` method with an error's message to
    # to log the error details again.

        logger.error error.full_message
        render(
            status: 500,
            json: {
                status: 500,
                errors: [{
                    type: error.class.to_s,
                    message: error.message
                }]
            }
        )
    end

    def record_invalid(error)
        # binding.pry

        record = error.record
        errors = record.errors.map do |field, message|
            {
                type: error.class.to_s,
                record_type: record.class.to_s,
                field: field,
                message: message
            }
        end
        render(
            status: 422, # Unprocessable Entity
            json: {
                status: 422,
                errors: errors
            }
        )
    end
end

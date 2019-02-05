class Api::V1::UsersController < Api::ApplicationController
    before_action :authenticate_user!

    def current
        render json: { status: 200, current_user: ActiveModelSerializers::SerializableResource.new(current_user).as_json }
    end
end

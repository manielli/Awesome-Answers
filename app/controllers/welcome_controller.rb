class WelcomeController < ApplicationController
    def index
        render :index
    end

    def contact
        # By default, rails will attempt to
        # render a view named after the action.
        # In other words, rails will always
        # `render :<action-method-name>`

        # For this action, rails is automatically
        # going to call `render :contact`
    end

    # In Rails, we call public methods of controllers
    # "actions". Actions return response to the client.
    def process_contact
        # In Rails, all of Express' req.params, req.query
        # and req.body are comined into the `params` object.

        # Use `render json: <object>` to inspect the object
        # as json in the browser much like we did with 
        # `res.send()` in Express.
        # render json: params
        # vs. JavaScript
        # res.send({ ...req.body, ...req.query, ...req.params })
        
        # In Rails, instance variables in the controller are
        # accessible in the rendered view as well.
        # Use them to pass value to your templates.
        @full_name = params[:full_name]
        @message = params[:message]
        @email = params[:email]
        
        render :thank_you
    end
end

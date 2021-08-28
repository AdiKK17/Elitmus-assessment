module Api
    class UserController < ApplicationController
        before_action :authorized , only: []

        
        #GET returns all advertisements
        def index
            users = User.all
            render json: users
        end

        #POST create a new user (Sign up)
        def create
            @user = User.create(user_params)
            if @user.valid?
                token = encode_token({user_id: @user.id})
                render json: {user: @user, token: token}
            else
                render json: {error: "Invalid username or password"}, status: 400 
            end
        end

        #POST (Sign in)
        def login
            @user = User.find_by(email: params[:email])

            if @user && @user.authenticate(params[:password])
                token = encode_token({user_id: @user.id})
                render json: {user: @user, token: token}
            else
                render json: {error: "Invalid username or password"}
            end
        end

        private

        def user_params
            params.permit(:name, :password, :email)
        end
        

    end
end
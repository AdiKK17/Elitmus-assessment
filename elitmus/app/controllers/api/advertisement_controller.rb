module Api
    class AdvertisementController < ApplicationController
        protect_from_forgery with: :null_session
        
        def index
            advertisements = Advertisement.all
            render json: AdvertisementSerializer.new(advertisements,options).serialized_json
        end

        def show
            advertisement = Advertisement.find_by(params[:id])

            render json: AdvertisementSerializer.new(advertisement,options).serialized_json
        end

        def create
            advertisement = Advertisement.new(advertisement_params)

            if advertisement.save
                render json: AdvertisementSerializer.new(advertisement).serialized_json
            else
                render json: {error:  advertisement.error.messages}, status: 422 
            end
        end

        def update
            advertisement = Advertisement.find_by(params[:id])

            if advertisement.update(advertisement_params)
                render json: AdvertisementSerializer.new(advertisement,options).serialized_json
            else
                render json: {error:  advertisement.error.messages}, status: 422 
            end

        end

        def destroy
            advertisement = Advertisement.find_by(params[:id])

            if advertisement.destroy
                render json: AdvertisementSerializer.new(advertisement).serialized_json
            else
                render json: {error:  advertisement.error.messages}, status: 422 
            end

        end

        private

        # this method is used for allowing only specified sets of attributes
        def advertisement_params
            params.require(:Advertisement).permit(:title,:description)
        end

        def options
            @options ||= {include: %i[comment]}
        end

    end
end
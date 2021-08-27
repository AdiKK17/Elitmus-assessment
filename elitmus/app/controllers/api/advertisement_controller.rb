module Api
    class AdvertisementController < ApplicationController
        # protect_from_forgery with: :null_session
        
        #GET returns all advertisements
        def index
            advertisements = Advertisement.all
            # render json: AdvertisementSerializer.new(advertisements,options).serialized_json
            # render json: AdvertisementSerializer.new(advertisements)
            render json: advertisements
        end

        #GET returns an individual advertisement based on id provided
        def show
            advertisement = Advertisement.find_by(id: params[:id])

            # render json: AdvertisementSerializer.new(advertisement,options).serialized_json
            render json: advertisement
        end

        #POST Create a new advertisement
        def create
            puts "??"
            puts advertisement_params
            puts "//"
            advertisement = Advertisement.new(advertisement_params)

            if advertisement.save
                # render json: AdvertisementSerializer.new(advertisement).serialized_json
                render json: advertisement
            else
                render json: {error:  advertisement.error.messages}, status: 422 
            end
        end

        #PUT/PATCH update the advertisement via its id
        def update
            advertisement = Advertisement.find_by(id: params[:id])

            if advertisement.update(advertisement_params)
                # render json: AdvertisementSerializer.new(advertisement,options).serialized_json
                render json: advertisement
            else
                render json: {error:  advertisement.error.messages}, status: 422 
            end

        end

        #DELETE delete the advertisement
        def destroy
            advertisement = Advertisement.find_by(id: params[:id])

            if advertisement.destroy
                # render json: AdvertisementSerializer.new(advertisement).serialized_json
                render json: advertisement
            else
                render json: {error:  advertisement.error.messages}, status: 422 
            end

        end

        private

        # this method is used for allowing only specified sets of attributes
        def advertisement_params
            params.require(:advertisement).permit(:title,:description)
        end

        def options
            @options ||= {include: %i[comment]}
        end

    end
end
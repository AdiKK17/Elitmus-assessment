module Api
    class CommentController < ApplicationController

        #GET get all comments
        def index
            comments = Comment.all
            # render json: CommentSerializer.new(comments).serialized_json
            render json: comments
        end

        #GET comments of a specific advertisement
        def show
            comments = Comment.where(advertisement_id: params[:id])

            # render json: AdvertisementSerializer.new(advertisement,options).serialized_json
            render json: comments
        end

        #POST create a new comment
        def create
            comment = Comment.new(comment_params)
        
            if comment.save
                # render json: CommentSerializer.new(comment).serialized_json
                render json: comment
            else
                render json: {error:  comment.error.messages}, status: 422 
            end
        end


        private

        # this method is used for allowing only specified sets of attributes
        def comment_params
            params.permit(:comment,:advertisement_id)
        end
        
    end
end
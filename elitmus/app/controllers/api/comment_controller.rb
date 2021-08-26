module Api
    class CommentController < ApplicationController

        def index
            comments = Comment.all
            render json: CommentSerializer.new(comments).serialized_json
        end

        def create
            comment = Comment.new(comment_params)

            if comment.save
                render json: CommentSerializer.new(comment).serialized_json
            else
                render json: {error:  comment.error.messages}, status: 422 
            end
        end


        private

        # this method is used for allowing only specified sets of attributes
        def comment_params
            params.require(:Comment).permit(:comment,:advertisement_id)
        end
        
    end
end
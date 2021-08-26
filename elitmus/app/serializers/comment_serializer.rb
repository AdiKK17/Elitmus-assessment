class CommentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :comment, :advertisement_id
end

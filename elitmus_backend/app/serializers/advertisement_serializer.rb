class AdvertisementSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description

  has_many :comment
end

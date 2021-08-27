class User < ApplicationRecord
    has_secure_password
    has_many :comment
    has_many :advertisement
end

class Product < ApplicationRecord
  mount_uploader :image, AvatarUploader
  belongs_to :category
end

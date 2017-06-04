class Item < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  default_scope { order(:name) }
  scope :of_category, -> (category_id) { where category_id: category_id }
  scope :of_retailer, -> (user_id) { where user_id: user_id }
end

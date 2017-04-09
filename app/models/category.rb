class Category < ActiveRecord::Base
  belongs_to :sub_main_category
  validates_presence_of :sub_main_category_id, :sequence_id, :name
  validates_numericality_of :sub_main_category_id, :sequence_id
  validates_uniqueness_of :name, :sequence_id, case_sensitive: false, scope: :sub_main_category_id, message: "already exist."
  default_scope { order(:sequence_id) }
  scope :of_sub_main_category, -> (sub_main_category_id) { where sub_main_category_id: sub_main_category_id }
end

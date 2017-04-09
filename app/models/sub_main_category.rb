class SubMainCategory < ActiveRecord::Base
  belongs_to :main_category
  validates_presence_of :main_category_id, :sequence_id, :name
  validates_numericality_of :main_category_id, :sequence_id
  validates_uniqueness_of :name, :sequence_id, case_sensitive: false, scope: :main_category_id, message: "already exist."
  default_scope { order(:sequence_id) }
  scope :of_main_category, -> (main_category_id) { where main_category_id: main_category_id }
end

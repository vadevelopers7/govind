class Category < ActiveRecord::Base
  belongs_to :city
  validates_presence_of :city_id, :sequence_id, :name, :icon
  validates_numericality_of :city_id, :sequence_id
  validates_uniqueness_of :name, :sequence_id, case_sensitive: false, scope: :city_id, message: "already exist."
  default_scope { order(:created_at) }
  scope :of_city, -> (city_id) { where city_id: city_id }
end

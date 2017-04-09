class City < ActiveRecord::Base
  belongs_to :state
  has_many :main_categories
  validates_presence_of :state_id, :name, :code
  validates_numericality_of :state_id
  validates_uniqueness_of :name, :code, case_sensitive: false, scope: :state_id, message: "already exist."
  default_scope { order(:name) }
  scope :of_state, -> (state_id) { where state_id: state_id }
end

class State < ActiveRecord::Base
  belongs_to :country
  has_many :cities
  validates_presence_of :country_id, :name, :code
  validates_numericality_of :country_id
  validates_uniqueness_of :name, :code, case_sensitive: false, scope: :country_id, message: "already exist."
  default_scope { order(:name) }
  scope :of_country, -> (country_id) { where country_id: country_id }
end

class State < ActiveRecord::Base
  belongs_to :country
  has_many :cities
  validates_presence_of :country_id, :name, :code
  validates_uniqueness_of :name, :code, case_sensitive: false, scope: :country_id, message: "already exist."
  scope :of_country, -> (id) { where country_id: id }
end

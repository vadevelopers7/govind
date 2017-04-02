class State < ActiveRecord::Base
  belongs_to :country
  validates_presence_of :country_id, :name, :code
end

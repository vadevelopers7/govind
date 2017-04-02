class City < ActiveRecord::Base
  belongs_to :state
  validates_presence_of :state_id, :name, :code
  validates_uniqueness_of :name, :code, case_sensitive: false, scope: :state_id, message: "already exist."
end

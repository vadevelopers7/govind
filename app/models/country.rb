class Country < ActiveRecord::Base
	has_many :states
  validates_presence_of :name, :code
  validates_uniqueness_of :name, :code, case_sensitive: false, message: "already exist."
  default_scope { order(:name) }
end

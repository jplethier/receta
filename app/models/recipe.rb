class Recipe < ActiveRecord::Base
  scope :by_name, lambda{ |keywords| where('name ilike ?',"%#{keywords}%") }

  validates :name, presence: true
end

class Recipe < ActiveRecord::Base
  scope :by_name, lambda{ |keywords| where('name ilike ?',"%#{keywords}%") }
end

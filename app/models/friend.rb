class Friend < ApplicationRecord
  belongs_to :model
  validates :first_name, presence: true
end

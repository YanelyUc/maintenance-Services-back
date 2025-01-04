class Car < ApplicationRecord
  START_DATE = 1900

  validates :plate_number, presence: true, uniqueness: true
  validates :year, presence: true, numericality: { only_integer: true,
                                                   greater_than_or_equal_to: START_DATE,
                                                   less_than_or_equal_to: Date.current.year }
end

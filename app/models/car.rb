class Car < ApplicationRecord
  START_DATE = 1900
  has_many :maintenance_services
  scope :active, -> { where(active: true) }
  scope :deleted, -> { where(active: false) }

  validates :plate_number, presence: true, uniqueness: true
  validates :year, presence: true, numericality: { only_integer: true,
                                                   greater_than_or_equal_to: START_DATE,
                                                   less_than_or_equal_to: Date.current.year }

  def active_maintenance_services
    maintenance_services.active
  end
end

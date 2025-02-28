class MaintenanceService < ApplicationRecord
  belongs_to :car
  scope :active, -> { where(active: true) }
  scope :deleted, -> { where(active: false) }
  enum status: { pending: 0, in_progress: 1, completed: 2 }

  validates :description, presence: true
  validates :date, presence: true
  validate :date_must_be_today_or_past

  private

  def date_must_be_today_or_past
    return date_error_message if date.present? && date > Date.current
  end

  def date_error_message
    errors.add(:date, 'must be less than or equal to today')
  end
end

class WorkshopApplication < ActiveRecord::Base
  # Attributes
  attr_accessible :amount, :applying_for_support, :other_sources, :still_attend, 
    :financial_aid_essay, :workshop_1_id, :workshop_2_id, :workshop_3_id,
    :workshop_essay, :profile_attributes

  # Relations
  belongs_to :user
  belongs_to :workshop_1, class_name: 'Workshop'
  belongs_to :workshop_2, class_name: 'Workshop'
  belongs_to :workshop_3, class_name: 'Workshop'

  has_one :profile, through: :user

  accepts_nested_attributes_for :profile, update_only: true

  # Valiations
  validates :workshop_1_id, :workshop_2_id, :workshop_3_id, presence: true
  validates :workshop_essay, presence: true
  validates :user_id, presence: true
  validates :amount, numericality: { greater_than: 0 }, if: :applying_for_support

  # Callbacks
  before_validation :strip_amount
  
  # Stop! Function time.
  def complete?
    if applying_for_support
      return false if financial_aid_essay.blank?
    end

    !workshop_essay.blank?
  end

  private
    def strip_amount
      self.amount = amount.to_s.gsub(/[^0-9]/i, '') if attribute_present?('amount')
    end
end

class DialogueApplication < ActiveRecord::Base
  belongs_to :user

  attr_accessible :conflict_essay, :dialogue_essay, :english_proficiency, :relationship_status, :user_id, :vision_essay, :ethnicity, :national, :realtives, :other_information
  validates_presence_of :relationship_status, :english_proficiency

  def complete?
    !dialogue_essay.blank? && !conflict_essay.blank? && !vision_essay.blank?
  end
end
class RelCreatorCreator < ActiveRecord::Base

  # Associations

  belongs_to :creator
  belongs_to :related_creator, :class_name => "Creator"
  belongs_to :creator_association_type

  def inverse_association
    creator.inverse_rel_creator_creators.find(:first, :conditions => "creator_id = #{self.related_creator_id}")
  end

end


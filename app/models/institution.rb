class Institution < ActiveRecord::Base

  belongs_to :updater,  :class_name => "User", :foreign_key => "updated_by"
  has_many :institution_editors, :dependent => :destroy, :order => :edited_at
  
  has_many :rel_creator_institutions
  has_many :creators, :through => :rel_creator_institutions

end


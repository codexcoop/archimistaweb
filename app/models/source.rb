class Source < ActiveRecord::Base

  # Associations
  belongs_to :source_type, :primary_key => :code, :foreign_key => :source_type_code
  belongs_to :updater, :class_name => "User", :foreign_key => "updated_by"

  has_many :source_urls
  has_many :digital_objects, :as => :attachable

  # Many-to-many associations (rel)
  has_many :rel_creator_sources
  has_many :rel_custodian_sources
  has_many :rel_fond_sources
  has_many :rel_unit_sources

end


class Creator < ActiveRecord::Base

  extend HasArchidate
  has_many_archidates

  def is_person?
    creator_type == 'P'
  end

  def is_family?
    creator_type == 'F'
  end

  def is_corporate?
    creator_type == "C"
  end

  # Associations

  belongs_to :creator_corporate_type

  has_many :creator_names
  has_one  :preferred_name, :class_name => 'CreatorName', :conditions => {:qualifier => 'A', :preferred => true}
  has_many :other_names, :class_name => 'CreatorName', :conditions => {:preferred => false}

  has_many :creator_legal_statuses
  has_many :creator_urls
  has_many :creator_identifiers
  has_many :creator_activities
  has_many :creator_editors, :order => :edited_at

  has_many :digital_objects, :as => :attachable, :order => :position

  has_one :first_digital_object,
    :as => :attachable,
    :class_name => DigitalObject,
    :conditions => {:position => 1}

  # Many-to-many associations (rel)

  has_many :rel_creator_creators
  has_many :related_creators, :through => :rel_creator_creators

  has_many :inverse_rel_creator_creators, :class_name => "RelCreatorCreator", :foreign_key => "related_creator_id"
  has_many :inverse_related_creators, :through => :inverse_rel_creator_creators, :source => :creator

  has_many :rel_creator_fonds
  has_many :fonds, :through => :rel_creator_fonds, :include => :preferred_event, :order => "fonds.name"

  has_many :rel_creator_institutions
  has_many :institutions, :through => :rel_creator_institutions

  has_many :rel_creator_sources
  has_many :sources, :through => :rel_creator_sources

  scope :list, select("creators.id, creators.creator_type, creator_names.name, creators.residence, creators.updated_at").
    joins(:preferred_name).
    includes(:preferred_event)

  # Virtual attributes

  def display_name
    preferred_name.name
  end

  def display_name_with_date
    return unless preferred_name
    preferred_event ? "#{h preferred_name.name} (#{preferred_event.full_display_date})" : preferred_name.name
  end

  def full_creator_type
    Creator.human_attribute_name(creator_type.to_sym)
  end

  alias_attribute :value, :name_with_preferred_date

  define_index do
    # fields
    indexes preferred_name(:name), :as => :display_name, :sortable => true
    indexes "LOWER(history)", :as => :content
    # attributes
    has first_digital_object(:id), :as => :digital_object_id, :type => :integer
    has preferred_event(:order_date), :as => :order_date
    has "CAST(EXTRACT(YEAR FROM creator_events.start_date_from) AS UNSIGNED)", :type => :integer, :as => :start_year
    has "CAST(EXTRACT(YEAR FROM creator_events.end_date_to) AS UNSIGNED)", :type => :integer, :as => :end_year
  end

end


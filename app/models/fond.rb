class Fond < ActiveRecord::Base

  extend ActsAsSequence
  acts_as_sequence

  extend HasArchidate
  has_many_archidates

  include Tree

  has_ancestry :cache_depth => true

  has_many :fond_names
  has_many :other_names, :class_name => 'FondName', :conditions => {:qualifier => 'O'}

  has_many :fond_editors
  has_many :fond_identifiers
  has_many :fond_langs
  has_many :fond_owners
  has_many :fond_urls

  has_many :units, :order => "units.sequence_number"
  # OPTIMIZE: disambiguare nome dell'associazione => descendant_units_of_root ???
  has_many :descendant_units, :class_name => "Unit", :foreign_key => :root_fond_id, :readonly => true

  def active_descendant_units_count
    Unit.count("id", :joins => :fond, :conditions => {:fond_id => subtree_ids, :fonds => {:trashed => false}})
  end

  has_many :digital_objects, :as => :attachable, :order => :position

  has_one :first_digital_object,
    :as => :attachable,
    :class_name => DigitalObject,
    :conditions => {:position => 1}

  # Many-to-many associations (rel)

  has_many :rel_custodian_fonds
  has_many :custodians, :through => :rel_custodian_fonds

  has_many :rel_creator_fonds
  has_many :creators, :through => :rel_creator_fonds

  has_many :rel_project_fonds
  has_many :projects, :through => :rel_project_fonds

  has_many :rel_fond_document_forms
  has_many :document_forms, :through => :rel_fond_document_forms, :order => "document_forms.name"

  has_many :rel_fond_sources
  has_many :sources, :through => :rel_fond_sources

  has_many :rel_fond_headings
  has_many :headings, :through => :rel_fond_headings

  # Virtual attributes

  def active?
    !trashed
  end

  def display_name_with_date
    return unless name.present?
    preferred_event ? "#{h name} (#{preferred_event.full_display_date})" : name
  end

  alias_attribute :display_name, :name
  alias_attribute :value, :display_name_with_date

  # Methods

  def has_subunits?
    Unit.exists?(["root_fond_id = ? AND ancestry_depth > 0", id])
  end

  def path_items(depth=0)
    path.from_depth(depth).all(:select => "id, name, ancestry")
  end

end


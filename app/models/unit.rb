class Unit < ActiveRecord::Base

  extend HasArchidate
  has_many_archidates

  MAX_LEVEL_OF_NODES = 2

  # Associations

  belongs_to :fond, :counter_cache => true

  has_ancestry :cache_depth => true

  has_many :unit_identifiers
  has_many :unit_other_reference_numbers
  has_many :unit_langs
  has_many :unit_damages
  has_many :unit_urls
  has_many :unit_editors, :order => :edited_at

  has_many :digital_objects, :as => :attachable, :order => :position

  has_one :first_digital_object,
    :as => :attachable,
    :class_name => DigitalObject,
    :conditions => {:position => 1}

  has_many :rel_unit_sources
  has_many :sources, :through => :rel_unit_sources

  has_many :rel_unit_headings
  has_many :headings, :through => :rel_unit_headings

  # Virtual attributes

  alias_attribute :name, :title
  alias_attribute :display_name, :title

  # FIXME (anche archimate): usare :format. Verificare dove usato (dopo modifica su pagine member)
  def level_type(short=false)
    short ? suffix = "_short" : suffix = ""
    case ancestry_depth
    when 0
      "#{I18n.t('level_file'+suffix)}"
    when 1
      "#{I18n.t('level_subfile'+suffix)}"
    when 2
      "#{I18n.t('level_subsubfile'+suffix)}"
    end
  end

  # Methods

  def full_path
    fond.path_items
  end

  def is_leaf?
    ancestry_depth == MAX_LEVEL_OF_NODES
  end

  def has_local_siblings?
    siblings.all(:conditions => "fond_id = #{self.fond_id}").count > 1
  end

  def is_movable_up?
    !is_root?
  end

  def is_movable_down?
    !is_leaf? &&
      has_local_siblings? &&
      !descendants.at_depth(MAX_LEVEL_OF_NODES).exists?
  end

  def is_not_movable?
    !is_movable_up? && !is_movable_down?
  end

  def is_iccd?
    tsk.present?
  end

  def formatted_title
    given_title? ? "[#{title}]" : title
  end

  # Methods related to sequence_number

  # Returns a hash of all the units of the *root_fond*,
  # where the key is the unit_id and the value is the display_sequence_number.
  # The hash is empty if the root_fond has no subunits.

  def self.display_sequence_numbers_of(root_fond, index = 0)
    display_sequence_numbers = {}
    if root_fond.has_subunits?
      units = self.all(:select => "id, position, ancestry, ancestry_depth",
        :conditions => "root_fond_id = #{root_fond.id} AND sequence_number IS NOT NULL",
        :order => "sequence_number")
      units.map do |u|
        value = case u.ancestry_depth
        when 0
          [index += 1].to_s
        when 1
          [index, u.position].join(".")
        when 2
          [index, u.parent.position, u.position].join(".")
        end
        display_sequence_numbers[u.id] = value
      end
    end
    display_sequence_numbers
  end

  # Method to be used in collection actions.
  def display_sequence_number_from_hash(display_sequence_numbers)
    display_sequence_numbers.present? ? display_sequence_numbers[id] : sequence_number
  end

  # Method to be used in member actions.
  def display_sequence_number
    self.class.display_sequence_numbers_of(fond.root)[id] || sequence_number
  end

  def prev_in_sequence
    self.class.find(:first, :select => "id",
      :conditions => "root_fond_id = #{root_fond_id} AND sequence_number = #{sequence_number-1}")
  end

  def next_in_sequence
    self.class.find(:first, :select => "id",
      :conditions => "root_fond_id = #{root_fond_id} AND sequence_number = #{sequence_number+1}")
  end

  define_index do
    # fields
    indexes "LOWER(units.title)", :as => :display_name, :sortable => true
    indexes "LOWER(content)", :as => :content
    # attributes
    has fond_id
    has root_fond_id, :facet => true
    has first_digital_object(:id), :as => :digital_object_id, :type => :integer
    has preferred_event(:order_date), :as => :order_date
    has "CAST(EXTRACT(YEAR FROM unit_events.start_date_from) AS UNSIGNED)", :type => :integer, :as => :start_year
    has "CAST(EXTRACT(YEAR FROM unit_events.end_date_to) AS UNSIGNED)", :type => :integer, :as => :end_year
  end

end

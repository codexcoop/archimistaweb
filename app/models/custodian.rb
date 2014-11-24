class Custodian < ActiveRecord::Base

  # Associations

  belongs_to :custodian_type
  has_one :import, :as => :importable

  has_many  :custodian_names
  has_one   :preferred_name, :class_name => 'CustodianName', :conditions => {:qualifier => 'AU', :preferred => true}
  has_many  :other_names, :class_name => 'CustodianName', :conditions => {:preferred => false}

  has_many  :custodian_identifiers
  has_many  :custodian_contacts
  has_one   :custodian_headquarter, :class_name => 'CustodianBuilding', :conditions => {:custodian_building_type => 'sede legale'}
  has_many  :custodian_other_buildings, :class_name => 'CustodianBuilding', :conditions => "custodian_building_type != '' AND custodian_building_type != 'sede legale'"
  has_many  :custodian_buildings, :class_name => 'CustodianBuilding'
  has_many  :custodian_owners
  has_many  :custodian_urls
  has_many  :custodian_editors, :order => :edited_at

  has_many  :digital_objects, :as => :attachable

  has_one :first_digital_object,
    :as => :attachable,
    :class_name => DigitalObject,
    :conditions => {:position => 1}

  # Many-to-many associations (rel)

  has_many  :rel_custodian_fonds
  has_many  :fonds, :through => :rel_custodian_fonds,
    :include => :preferred_event, :order => "fonds.name"

  has_many :rel_custodian_sources
  has_many :sources, :through => :rel_custodian_sources

  scope :list, select("custodians.id, custodian_names.name, custodians.updated_at").
    joins(:preferred_name).includes(:custodian_headquarter)

  # Virtual attributes

  def display_name
    preferred_name.name
  end

  def headquarter_address
    if custodian_headquarter.present?
      [
        custodian_headquarter.address,
        custodian_headquarter.postcode,
        custodian_headquarter.city,
        custodian_headquarter.country
      ].
        delete_if{|fragment| fragment.blank?}.
        join(" ")
    end
  end

end


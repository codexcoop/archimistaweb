ThinkingSphinx::Index.define :creator, :with => :active_record do
  indexes preferred_name(:name), :as => :display_name, :sortable => true
  indexes "LOWER(history)", :as => :content

  has first_digital_object(:id), :as => :digital_object_id, :type => :integer
  has preferred_event(:order_date), :as => :order_date
  has "CAST(EXTRACT(YEAR FROM creator_events.start_date_from) AS UNSIGNED)", :type => :integer, :as => :start_year
  has "CAST(EXTRACT(YEAR FROM creator_events.end_date_to) AS UNSIGNED)", :type => :integer, :as => :end_year
end

ThinkingSphinx::Index.define :custodian, :with => :active_record do
  indexes preferred_name(:name), :as => :display_name, :sortable => true

  has first_digital_object(:id), :as => :digital_object_id, :type => :integer
  has "NULL", :as => :order_date, :type => :string
  has "CAST(EXTRACT(YEAR FROM '0000-00-00') AS UNSIGNED)", :type => :integer, :as => :start_year
  has "CAST(EXTRACT(YEAR FROM CURRENT_DATE) AS UNSIGNED)", :type => :integer, :as => :end_year
end

ThinkingSphinx::Index.define :fond, :with => :active_record do
  indexes "LOWER(name)", :as => :display_name, :sortable => true
  indexes "LOWER(fonds.description)", :as => :content

  has first_digital_object(:id), :as => :digital_object_id, :type => :integer
  has preferred_event(:order_date), :as => :order_date
  has "CAST(EXTRACT(YEAR FROM fond_events.start_date_from) AS UNSIGNED)", :type => :integer, :as => :start_year
  has "CAST(EXTRACT(YEAR FROM fond_events.end_date_to) AS UNSIGNED)", :type => :integer, :as => :end_year
end

ThinkingSphinx::Index.define :unit, :with => :active_record do
  indexes "LOWER(units.title)", :as => :display_name, :sortable => true
  indexes "LOWER(content)", :as => :content

  has fond_id
  has root_fond_id, :facet => true
  has first_digital_object(:id), :as => :digital_object_id, :type => :integer
  has preferred_event(:order_date), :as => :order_date
  has "CAST(EXTRACT(YEAR FROM unit_events.start_date_from) AS UNSIGNED)", :type => :integer, :as => :start_year
  has "CAST(EXTRACT(YEAR FROM unit_events.end_date_to) AS UNSIGNED)", :type => :integer, :as => :end_year
end
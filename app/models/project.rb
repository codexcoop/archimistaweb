class Project < ActiveRecord::Base

  # Associations

  has_many  :project_credits, :dependent => :destroy
  has_many  :project_urls, :dependent => :destroy
  has_many  :project_managers, :class_name => 'ProjectCredit', :conditions => {:credit_type => 'PM'}
  has_many  :project_stakeholders, :class_name => 'ProjectCredit', :conditions => {:credit_type => 'PS'}

  # Many-to-many associations (rel)

  has_many :rel_project_fonds, :dependent => :destroy, :autosave => true
  has_many :fonds, :through => :rel_project_fonds,
    :include => :preferred_event, :order => "fonds.name"

  # Virtual attributes
  alias_attribute :display_name, :name

  def display_date
    if start_year == end_year
      "#{start_year.to_s}"
    else
      "#{start_year.to_s}-#{end_year.to_s}"
    end
  end

end


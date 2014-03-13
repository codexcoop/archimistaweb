module HasArchidate

  attr_accessor  :archidate_class_name

  def has_many_archidates

    self.archidate_class_name = "#{self.name}Event"

    has_many :events,
      :class_name => archidate_class_name,
      :order => 'preferred DESC, order_date'

    has_one :preferred_event,
      :class_name => archidate_class_name,
      :conditions => {:preferred => true}
  end

  def archidate_class
    @archidate_class ||= archidate_class_name.constantize
  end

  def archidate_table
    @archidate_table ||= archidate_class.table_name
  end

end

module Archidate

  attr_accessor :entity_class_name

  def acts_as_archidate
    include ArchidateInstanceMethods

    self.entity_class_name = self.name.sub(/Event\Z/,'')
    belongs_to :entity, :class_name => @entity_class_name
  end
end

module ArchidateInstanceMethods

  def full_display_date
    if equal_bound_fields?
      start_date_display.squish
    else
      "#{start_date_display} - #{end_date_display}".squish
    end
  end

  def full_display_date_with_place
    a = []
    b = []

    a << start_date_place unless start_date_place.blank?
    a << start_date_display

    if equal_bound_fields?
      a.join(", ").squish.gsub(/0*(\d+)/,'\1')
    else
      b << end_date_place unless end_date_place.blank?
      b << end_date_display
      "#{a.join(", ")} - #{b.join(", ")}".squish.gsub(/0*(\d+)/,'\1')
    end
  end

  def equal_bound_fields?
    start_date_from?    && end_date_from?   &&
    start_date_to?      && end_date_to?     &&
    start_date_format?  && end_date_format? &&
    start_date_spec?    && end_date_spec?   &&
    start_date_valid?   && end_date_valid?  &&
    start_date_from     == end_date_from    &&
    start_date_to       == end_date_to      &&
    start_date_format   == end_date_format  &&
    start_date_spec     == end_date_spec    &&
    start_date_valid    == end_date_valid
  end

end

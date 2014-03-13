class Editor < ActiveRecord::Base

  # Virtual attributes

  def full_name
    "#{first_name} #{last_name}"
  end

  def reverse_full_name
    "#{last_name}, #{first_name}"
  end

  def value
    full_name
  end

end


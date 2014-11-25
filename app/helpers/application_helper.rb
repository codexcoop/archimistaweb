module ApplicationHelper

  def fluid_layout?
    ["fonds", "units"].include?(controller_name) && action_name == "show"
  end

  def container_class
    fluid_layout? ? "container-fluid" : "container"
  end

  def title(page_title)
    content_for (:title) { page_title }
  end

  def active_if(controller, match)
    " active " if controller == match
  end

  def nav_link(target_controller, path)
    active = controller_name == target_controller ? 'active' : nil

    content_tag(:li, :class => active) do
      link_to t(target_controller), path
    end
  end

  # Enforce the textilize method:
  # - do not convert square brackets, minus and plus signs
  # - unescape the entities for special characters that have been escaped by RedCloth
  def textilize_with_entities(text)
    text = text.gsub(/\[/, "&#91;").gsub(/\]/, "&#93;").
      gsub(/\-/, "&#8722;").
      gsub(/\+/, "&#43;")
    textilize(escape_once(text)).gsub("&amp;#", "&#")
  end

  def show_item(item, options=['', ''], translate=nil)
    if item.present?
      string = translate.present? ? t(item) : item
      options[0] + string + options[1]
    else
      ""
    end
  end

  # ShowEditor
  def show_editor(object)
    string = ""
    string += "#{object.editing_type.capitalize}: " unless object.editing_type.blank?
    string += object.name
    string += " (#{object.qualifier})" unless object.qualifier.blank?
    string += " - <span>#{t('edited_at')}: #{l object.edited_at, :format => :long}</span>" unless object.edited_at.blank?
    string
  end

  def formatted_source(source)
    if source.use_legacy?
      source.legacy_description.gsub(/<C>|<N>|<T>|<CR>/i, '')
    else
      [
        source.author,
        (source.title.present? ? content_tag(:em, source.title) : nil),
        source.publisher,
        source.date_string
      ].
        delete_if{|fragment| fragment.blank?}.
        join(", ")
    end
  end

  def formatted_editor(editor)
    [
      editor.name,
      (editor.qualifier.present? ? editor.qualifier : nil),
      (editor.editing_type.present? ? editor.editing_type : nil)
    ].
      delete_if{|fragment| fragment.blank?}.
      join(", ")
  end

  def formatted_custodian_building(building)
    [
      building.address,
      building.postcode,
      building.city,
      building.country
    ].
      delete_if{|fragment| fragment.blank?}.
      join(" ")
  end

  def permalink(object)
    content = case object.class.name
    when 'Unit'
      link_to fond_unit_url("#{object.send("fond_id")}", object), fond_unit_url("#{object.send("fond_id")}", object)
    else
      link_to send("#{object.class.name.underscore}_url", object)
    end
    content_tag :p, :id => "permalink" do
      "Link risorsa: #{content}".html_safe
    end
  end

end

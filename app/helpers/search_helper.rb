module SearchHelper

  def orders
    ['relevance', 'order_date']
  end

  def switch_order(current)
    content = []
    orders.each do |order|
      get = params.merge({:sort => order})
      content << link_to_unless(current == order, t(order), search_path(get))
    end
    content.join(' | ').html_safe
  end

  def rejectable_keys
    ['page', 'scope', 'root_fond_id']
  end

  # OPTIMIZE: rendere omogeneo il codice (ora ci sono approcci diversi per casi simili).
  # Vedi OPTIMIZE successivo.
  def filter_by_scope(klass)
    get = params.merge({:scope => klass.singularize, :page => nil})
    link_to_unless(params[:scope] == klass.singularize, "#{t(klass)}", search_path(get))
  end

  def remove_filters
    if params.include?(:scope)
      get = params.reject {|k, v| rejectable_keys.include?(k)}
      link_to raw('<i class="icon-remove"></i> Rimuovi filtri'), search_path(get)
    end
  end

  # OPTIMIZE: forse più comodo spostare nella vista o in un partial. Vedremo.
  def units_facets(facets)
    content = ""
    ids = []
    names = {}

    facets.each_with_index do |root_fond, index|
      ids <<  root_fond[0]
    end

    Fond.select("id, name").where("id IN (?)", ids).each do |f|
      names[f.id] = f.name
    end

    facets.each_with_index do |root_fond, index|
      name = names[root_fond[0]]
      get = params.merge({:root_fond_id => root_fond[0], :page => nil})

      content += "<li>"
      content += link_to_unless(params[:root_fond_id] == root_fond[0].to_s, "#{name}", search_path(get))
      content += "&nbsp;<em>(#{number_with_delimiter(root_fond[1])})</em>&nbsp;"
      content += link_to "[ X ]", search_path(get.merge({:root_fond_id => nil})) if params[:root_fond_id] == root_fond[0].to_s
      content += "</li>"
    end
    content.html_safe
  end

  def url_builder(entity)
    klass = entity.class.name.downcase
    url = case klass
    when 'unit'
      Rails.application.routes.url_helpers.send("fond_unit_path", entity.fond_id, entity.id)
    else
      Rails.application.routes.url_helpers.send("#{klass}_path", entity.id)
    end
    "http://" + request.host_with_port + url
  end

end
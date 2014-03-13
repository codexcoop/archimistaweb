module Tree

  def fast_subtree_to_jstree_hash(prepared_subtree=nil)
    prepared_subtree ||= subtree.select_for_tree.order_for_tree

    groups = break_groups_by_key(prepared_subtree,
      :key => 'ancestor_ids',
      :attr => 'prepared_jstree_hash',
      :seed => true)

    list = [groups.first.second]

    groups[1..-1].each do |ancestor_ids, *hashes|
      target_element = find_in_nested_list(list, ancestor_ids[depth..-1])
      target_element[:children] = hashes if target_element
    end

    list
  end

  def to_jstree_hash
    {
      :data => {
        :title => name,
        :attr => {
          :href => "/fonds/#{id}",
          :class => "changeable",
        }
      },
      :attr => {
        :id => "node-#{id}",
        :class => "node",
        :'data-units' => units_count
      }
    }
  end

  def prepared_jstree_hash
    {:id => id}.update(to_jstree_hash)
  end

  def break_groups_by_key(array, opts={})

    return self if array.empty?

    seed        = opts[:seed]
    key_attr    = opts[:key].to_sym
    group_attr  = opts[:attr].to_sym

    groups = []

    # seed the groups
    if seed || array.size == 1
      groups << [array.first.send(key_attr), array.first.send(group_attr)]
    end

    # create the groups
    array.each_cons(2) do |a,b|
      if b.send(key_attr) != a.send(key_attr)
        groups << [b.send(key_attr), b.send(group_attr)]
      else
        groups.last << b.send(group_attr)
      end
    end

    groups
  end

  def find_in_nested_list(list, ids)
    last_id = ids.pop

    element_before_last = ids.inject(list) do |restricted_list, current_id|
      restricted_list.find{|el| el[:id] == current_id}[:children]
    end

    element_before_last.find{|el| el[:id] == last_id}
  end

end

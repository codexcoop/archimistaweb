module ActsAsSequence

  attr_accessor :order_for_tree_options,
    :select_for_tree_options,
    :node_name,
    :external_node_name,
    :external_nodes_class

  def acts_as_sequence

    self.node_name = :name
    self.external_node_name = :name
    self.external_nodes_class = nil

    self.select_for_tree_options = "#{table_name}.id,
                                    #{table_name}.sequence_number,
                                    #{table_name}.ancestry,
                                    #{table_name}.ancestry_depth,
                                    #{table_name}.#{node_name},
                                    #{table_name}.position,
                                    #{table_name}.trashed,
                                    #{table_name}.units_count".squish

    self.order_for_tree_options  = "#{table_name}.ancestry_depth,
                                    #{table_name}.ancestry,
                                    #{table_name}.position".squish

    scope :order_for_tree, order(order_for_tree_options)
    scope :select_for_tree, select(select_for_tree_options)
    scope :active, where(:trashed => false)

  end

end

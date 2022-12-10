class Node
  def initialize(left_child, data, right_child)
    @left_child = left_child
    @data = data
    @right_child = right_child
  end
end

module Comparable
  def compare_nodes(a, b)
    a.data = b.data
  end
end

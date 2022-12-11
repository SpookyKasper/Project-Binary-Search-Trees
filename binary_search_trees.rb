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

# Build a Tree class which accepts an array when initialized.
# The Tree class should have a root attribute which uses the return value of
# build_tree which you’ll write next.

# Write a #build_tree method which takes an array of data
# (e.g. [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]) and turns it into a
# balanced binary tree full of Node objects appropriately placed
# (don’t forget to sort and remove duplicates!).
# The #build_tree method should return the level-0 root node.

class Tree
  def initialize(array)
    @root = build_tree(array)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def build_tree(array)
    mid_idx = array.length/2 - 1
    mid = array[mid_idx]
    left_half = array[0..(mid_idx - 1)]
    right_half = array[(mid_idx+1)..-1]
    p left_half
    p right_half

  end

end

simple_array = [1, 2, 3, 4]
data_arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]


my_tree = Tree.new(simple_array)

class Node
  attr_accessor :left, :data, :right

  def initialize(left, data, right)
    @left = left
    @data = data
    @right = right
  end
end

class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def build_tree(array)
    return Node.new(nil, array[0], nil) if array.length < 2

    mid_idx = array.length/2
    mid = array[mid_idx]
    left_half = (array[0..(mid_idx - 1)])
    right_half = (array[(mid_idx+1)..-1])
    left_child = build_tree(left_half)
    right_child = build_tree(right_half)
    return Node.new(left_child, mid, right_child)
  end
end

extr_simple_arr = [8]
simple_array = [1, 2, 3, 5, 7]
data_arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
clean_data = data_arr.sort.uniq


my_simple_tree = Tree.new(simple_array)
my_complicated_tree = Tree.new(clean_data)

puts my_simple_tree.pretty_print
puts my_complicated_tree.pretty_print


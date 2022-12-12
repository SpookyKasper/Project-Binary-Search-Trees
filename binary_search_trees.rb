class Node
  attr_accessor :left, :data, :right

  def initialize(data, left=nil, right=nil)
    @data = data
    @left = left
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
    return nil if array.empty?
    return Node.new(array[0]) if array.length < 2

    root_index = array.length/2
    root = array[root_index]
    left = array[0..root_index-1]
    right = array[root_index+1..]
    left_child = build_tree(left)
    right_child = build_tree(right)
    return Node.new(root, left_child, right_child)
  end

  def insert(value, node=@root)
    if value < node.data
      node.left.nil? ? (node.left = Node.new(value) and return ) : left_sub_tree = node.left
      insert(value, left_sub_tree)
    else
      node.right.nil? ? (node.right = Node.new(value) and return) : right_sub_tree = node.right
      insert(value, right_sub_tree)
    end
  end

  # Pseudo code for delete method
  # start with deleting leafs
  # Given a value
  # Look for that value in the tree as following
  # start at the root, if the value is smaller than the root.data
    # recursively call the delete method on the left sub tree
    # else recursively call delete on the right sub tree
  # Base case, if next.left or next.right == the value
  # next.left or next.right gets nil instead

  def delete(value, node=@root)
    # if node.left.data == value || node.right.data == value
    #   node.left == value ? node.left = nil : node.right = nil
    #   return
    # end
    if value < node.data
      p 'goes left'
      node.left.data == value ? (node.left = nil and return) : delete(value, node.left)
    else
      p 'goes right'
      node.right.data == value ? (node.right = nil and return) : delete(value, node.right)
    end
  end
end

extr_simple_arr = [8]
simple_array = [1, 2, 3, 4, 5, 6, 7]
data_arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
clean_data = data_arr.sort.uniq


my_simple_tree = Tree.new(simple_array)
my_complicated_tree = Tree.new(clean_data)


# my_complicated_tree.pretty_print
# my_complicated_tree.insert(24)
# my_complicated_tree.pretty_print

my_simple_tree.pretty_print
my_simple_tree.insert(8)
my_simple_tree.pretty_print

my_simple_tree.delete(3)
my_simple_tree.pretty_print

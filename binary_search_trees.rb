class Node
  include Comparable

  attr_accessor :left, :data, :right

  def initialize(data, left=nil, right=nil)
    @data = data
    @left = left
    @right = right
  end

  def count_children
    count = 0
    unless @left.nil? then count += 1 end
    unless @right.nil? then count += 1 end
    count
  end
end

module Comparable
  def compare(node1, node2)
    node1.data == node2.data
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

    array = array.uniq.sort
    root_index = array.length/2
    root = array[root_index]
    left = array[0..root_index-1]
    right = array[root_index+1..]
    left_child = build_tree(left)
    right_child = build_tree(right)
    Node.new(root, left_child, right_child)
  end

  def insert(value, node = @root)
    return if value == node.data

    if value < node.data
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    else
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end

  def find(value, root=@root)
    return if root.nil?
    return root if root.data == value

    value < root.data ? find(value, root.left) : find(value, root.right)
  end

  def delete(value, root = @root, mama = @root)
    return if root.nil?
    if value == root.data then delete_node(root, mama) and return value end

    value < root.data ? delete(value, root.left, root) : delete(value, root.right, root)
  end

  def delete_node(root, mama)
    case root.count_children
    when 0
      root.data < mama.data ? mama.left = nil : mama.right = nil
    when 1
      child = root.left || root.right
      root.data < mama.data ? mama.left = child : mama.right = child
    when 2
      papa = root
      current_node = root.right
      until current_node.left.nil?
        papa = current_node
        current_node = current_node.left
      end
      root.data = current_node.data
      delete_node(current_node, papa)
    end
  end

  def level_order_it(&block)
    result = []
    discovered_nodes = [@root]
    until discovered_nodes.empty?
      current_node = discovered_nodes[0]
      discovered_nodes << current_node.left unless current_node.left.nil?
      discovered_nodes << current_node.right unless current_node.right.nil?
      block ? result << (yield current_node) : result << current_node.data
      discovered_nodes.shift
    end
    result
  end

  def level_order_rec(result = [], discovered_nodes = [@root], &block)
    return result if discovered_nodes.empty?

    current_node = discovered_nodes[0]
    discovered_nodes << current_node.left unless current_node.left.nil?
    discovered_nodes << current_node.right unless current_node.right.nil?
    block ? result << (yield current_node) : result << current_node.data
    discovered_nodes.shift
    level_order_rec(result, discovered_nodes, &block)
  end

  def inorder(current_node = @root, result = [], &block)
    return if current_node.nil?

    inorder(current_node.left, result, &block)
    block ? (yield current_node) : result << current_node.data
    inorder(current_node.right, result, &block)
    result
  end

  def preorder(current_node = @root, result = [], &block)
    return if current_node.nil?

    block ? (yield current_node) : result << current_node.data
    preorder(current_node.left, result, &block)
    preorder(current_node.right, result, &block)
    result
  end

  def postorder(current_node = @root, result = [], &block)
    return if current_node.nil?

    postorder(current_node.left, result, &block)
    postorder(current_node.right, result, &block)
    block ? (yield current_node) : result << current_node.data
    result
  end

  # pseudocode height
  # given a node return the longest path to a leaf
  # check the longest path on the left
  # check the longest path on the right
  # compare the paths an return the longest

  def height(node, path_left = 0, path_right = 0, max_height = 0)
    # check the longest path on the left
    puts "this is the current node #{node.data}"
    # puts "this is the current path_left size #{path_left}"
    return 0 if node.left.nil? && node.right.nil?

    if node.left
      path_left = 1 + height(node.left, path_left, path_right, max_height)
    end
    # puts "this is the path left after the depth #{path_left}"
    # check the longest path on the right
    if node.right
      path_right = 1 + height(node.right, path_left, path_right, max_height)
    end
    # puts "this is the path right after the depth #{path_right}"

    height = path_left >= path_right ? path_left : path_right
    # max_height = max_height >= height ? max_height : height
    # max_height
    height

    # compare the paths and return the longest
  end

end

array_3 = [1, 2, 3, 5]
simple_array = [1, 2, 3, 4, 5, 6, 7, 8]
data_arr = [1, 7, 4, 24, 23, 10, 12, 9, 4, 3, 5, 7, 9, 67, 6345, 324, 3234, 12338, 12, 234, 29, 98, 200, 245, 11]

simple = Tree.new(array_3)
my_simple_tree = Tree.new(simple_array)
my_treee = Tree.new(data_arr)


simple.pretty_print
node = simple.find(3)
p simple.height(node)

# p my_simple_tree.inorder
# my_simple_tree.pretty_print
# node = my_simple_tree.find(5)
# p my_simple_tree.height(node)

my_treee.pretty_print
my_treee.delete(98)
my_treee.pretty_print
# node = my_treee.find(24)
# p my_treee.height(node)

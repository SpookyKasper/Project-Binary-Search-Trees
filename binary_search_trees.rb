class Node
  include Comparable

  attr_accessor :left, :data, :right, :is_leaf

  def initialize(data, left=nil, right=nil)
    @data = data
    @left = left
    @right = right
    @is_leaf = @left.nil? && @right.nil?
    @children = count_chidren
  end

  def count_chidren
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

    if value == root.data
      delete_node(root, mama)
      return value
    end

    if value < root.data
      delete(value, root.left, root)
    elsif value > root.data
      delete(value, root.right, root)
    end
  end

  def delete_node(root, mama)
    case root.count_chidren
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

  # pseudo code for level_order_it
  # given a tree
  # start at the root
  # push the root node to the discovered nodes array
  # push the root's children to the discovered nodes array
  # check the data of the first node in the queue and delete it
  # repeat process for the next node in the queue

  def level_order_it(&block)
    result = []
    discovered_nodes = [@root]
    until discovered_nodes.empty?
      current_node = discovered_nodes[0]
      discovered_nodes << current_node.left unless current_node.left.nil?
      discovered_nodes << current_node.right unless current_node.right.nil?
      if block
        block_result = yield current_node
        result << block_result
      else
        result << current_node.data
      end
      discovered_nodes.shift
    end
    result
  end

  # pseudo code for recursive level order
  # given a tree
  # start at the node
  # push the node and it's children to the discovered nodes queue (array) unless the children are nil
  # if the discovered nodes queue is empty return
  # else call the level order on the first item of the queue

  def level_order_rec(result = [], discovered_nodes = [@root])
    return result if discovered_nodes.empty?

    current_node = discovered_nodes[0]
    result << current_node.data
    discovered_nodes << current_node.left unless current_node.left.nil?
    discovered_nodes << current_node.right unless current_node.right.nil?
    discovered_nodes.shift
    level_order_rec(result, discovered_nodes)
  end
end

simple_array = [1, 2, 3, 4, 5, 6]
data_arr = [1, 7, 4, 24, 23, 10, 12, 9, 4, 3, 5, 7, 9, 67, 6345, 324, 3234, 12338, 12, 234, 29, 98, 200, 245, 11]

my_simple_tree = Tree.new(simple_array)
my_treee = Tree.new(data_arr)

# my_simple_tree.pretty_print
# p my_simple_tree.level_order_it
# my_simple_tree.pretty_print
# p my_simple_tree.level_order_it {|node| node.data += 3}
# my_simple_tree.pretty_print

my_simple_tree.delete(4)
my_simple_tree.pretty_print
p my_simple_tree.level_order_rec



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

  def find_next_and_delete(node)
    current_node = node
    until current_node.left.nil?
      current_node = node.left
    end
    current_node
  end

  def delete(value, node=@root, mama=@root)
    return if node.nil?

    puts "this is the value we want to delete #{value}"
    puts "this is the ndoe we are at #{node.data}"
    puts "this is the mama #{mama.data}"

    if node.data == value
      case node.count_chidren
      when 0
        mama.data < node.data ? mama.right = nil : mama.left = nil
      when 1
        mama.data < node.data ? mama.right = node.right || node.left : mama.left = node.right || node.left
      when 2
        mama = node
        current_node = node.right
        find_next_and_delete(current_node)
        # until current_node.left.nil?
        #   mama = current_node
        #   current_node = current_node.left
        # end
        # if mama == current_node
        #   node.data = current_node.data
        #   node.right = current_node.right
        #   return
        # end
        # mama.left = delete(current_node.data, current_node, mama)
        # node.data = current_node.data
        return
      end
    end
    value < node.data ? delete(value, node.left, node) : delete(value, node.right, node)
  end

    # pseudocode delete
  # given a value we want to delete
  # current_node at the root of the tree
  # if the value is equal to the root data
    # assign to the root the returned node off calling delete_node on it
  # if the value is smaller than the root data
    # assign to the left sub tree the node returned by calling the delete method on it
  # if it bigger assign the to the right subtree the node returned by calling the delete method on it

  # pseudocode delete_node
  # given a node wa are at that we want to delete and return a value for the parrent
  # if our node as no children return nil

  def new_delete(value, root = @root, mama = @root)
    if value == root.data
      mama = new_delete_node(root, mama)
      return mama
    end

    if value < root.data
      mama = new_delete(value, root.left, root)
    elsif value > root.data
      mama = new_delete(value, root.right, root)
    end
  end

  def new_delete_node(root, mama)
    case root.count_chidren
    when 0
      puts "#{root.data} as no children"
      root.data < mama.data ? mama.left = nil : mama.right = nil
      mama
    when 1
      puts "#{root.data} as only one child"
      child = root.left || root.right
      root.data < mama.data ? mama.left = child : mama.right = child
      mama
    when 2
      puts "#{root.data} as 2 childs"
      current_node = root.right
      until current_node.left.nil?
        papa = current_node
        current_node = current_node.left
      end
      data = current_node.data
      new_delete_node(current_node, papa)
      root.data = data
      mama
    end
  end
end

simple_array = [1, 2, 3, 4, 5, 6, 7]
data_arr = [1, 7, 4, 23, 10, 12, 9, 4, 3, 5, 7, 9, 67, 6345, 324, 3234, 12338, 12, 234, 29, 98, 200, 245, 11]

my_simple_tree = Tree.new(simple_array)
my_complicated_tree = Tree.new(data_arr)


my_complicated_tree.pretty_print
my_complicated_tree.new_delete(4)
my_complicated_tree.pretty_print

my_complicated_tree.new_delete(29)
my_complicated_tree.pretty_print
my_complicated_tree.new_delete(245)
my_complicated_tree.pretty_print

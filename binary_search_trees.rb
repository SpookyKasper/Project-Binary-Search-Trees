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
    unless @left.nil?
      count += 1
    end
    unless @right.nil?
      count += 1
    end
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

    root_index = array.length/2
    root = array[root_index]
    left = array[0..root_index-1]
    right = array[root_index+1..]
    left_child = build_tree(left)
    right_child = build_tree(right)
    return Node.new(root, left_child, right_child)
  end

  def insert(value, node=@root)
    return if value == node.data
    if value < node.data
      node.left.nil? ? (node.left = Node.new(value) and return ) : left_sub_tree = node.left
      insert(value, left_sub_tree)
    else
      node.right.nil? ? (node.right = Node.new(value) and return) : right_sub_tree = node.right
      insert(value, right_sub_tree)
    end
  end

  def find(value, root=@root)
    return if root.nil?
    return root if root.data == value
    value < root.data ? find(value, root.left) : find(value, root.right)
  end

  # Pseudocode Delete method
  # given the value of the node we want to delete, let's call that node john_go
  # search the tree for john_go as following
  # start at the root of the tree
  # if the root.data == value, we found john_go we can assign it the result of the the delete_node method and return
  # if the value is smaller than the root.data
    # we call delete on the left sub tree
  # if the value is bigger than the root.data
    # we call delete on the right sub tree

  # pseudocode delete_node(node)
  # given a node we want to delete, we want to assign it a value depending on its descendence, we have 3 possibilities
    # if that node is a leaf the whe return nil
    # if that node has only a right child he becomes that right child instead
    # if that node has 2 childs we want to call find_next_and_replace on it

  # pseudocode find_next_nad replace
    # given a node with 2 children, we want to assign it the smallest value to it's right as following:
    # we start at the right children, then we go as far left as we can
    # when we reach the far left we return the data and that node gets the result of calling delete on it

  def delete(value, node=@root, mama=@root)
    return if node.nil?
    puts "This is the current node #{node.data}, this is the mama #{mama.data}"
    if node.data == value
      puts "THIS IS what we are delting #{node.data}"
      num_children = node.count_chidren
      puts "this is the number of children of the node we are deleting #{num_children}"
      case num_children
      when 0
        if mama.data < node.data
          mama.right = nil
        else
          mama.left = nil
        end
        return
      when 1
        to_return = node.right || node.left
        node = node.right || node.left
        return to_return
      when 2
        current_node = node.right
        until current_node.left == nil
          papa = current_node
          puts "this is the papa of what we are gonna delete to replace the main delete #{papa.data}"
          current_node = current_node.left
        end
        to_return = current_node
        puts "This is right smallest value #{to_return.data}"
        if papa.nil?
          node.data = to_return.data
          node.right = to_return.right
          return
        end
        # puts "this is the papa left before deletin #{papa.left.data}"
        papa.left = delete(current_node.data, current_node, papa)
        puts "This is the papa left #{papa.left} after deleting"
        node.data = to_return.data
        return to_return
      end
    end
    value < node.data ? delete(value, node.left, node) : delete(value, node.right, node)
  end

end

extr_simple_arr = [8]
simple_array = [1, 2, 3, 4, 5, 6, 7]
data_arr = [1, 7, 4, 23, 10, 12, 9, 4, 3, 5, 7, 9, 67, 6345, 324, 3234, 12338, 12, 234, 29, 98]
clean_data = data_arr.sort.uniq


my_simple_tree = Tree.new(simple_array)
my_complicated_tree = Tree.new(clean_data)


my_complicated_tree.pretty_print
my_complicated_tree.delete(5)
my_complicated_tree.pretty_print
puts "next delete operation"
my_complicated_tree.delete(7)
my_complicated_tree.pretty_print
puts 'next delete operation'
my_complicated_tree.delete(234)
my_complicated_tree.pretty_print
my_complicated_tree.delete(10)
my_complicated_tree.pretty_print


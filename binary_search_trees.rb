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

  def recursive_find(value, root=@root)
    return if root.nil?
    return root if root.data == value
    value < root.data ? recursive_find(value, root.left) : recursive_find(value, root.right)
  end


  def find(value)
    current_node = @root
    until current_node.data == value || current_node.is_leaf
      if value < current_node.data
        current_node = current_node.left
      else
        current_node = current_node.right
      end
    end
    current_node.data == value ? current_node : nil
  end

  def find_next_bigger(value)
    return nil if find(value).right.nil?
    current_node = find(value).right
    until current_node.left.nil?
      current_node = current_node.left
    end
    current_node
  end

  # Algo for delete method
  # Given a value look for that value in the Tree as following:
  # Start at the root:
  # compare the root.data with the value
    # If the root.data equals the value, we found the node we want to delete go to delete step
    # Otherwise
      # if the value is smaller than the root.data
        # check if the left child data is equal to the value
          # if it is go to the delete step
          # otherwise recursively call delete on the left child
      # if the value is bigger than the root.data
        # check if the right child data is equal to the value
          # if it is got to the delete step
          # otherwise recursively call delete on the right child
  # If we reach the end of the tree without finding the value return nil
  # If we found the value is the left or right child root.data
  # Deleting step:
  # 3 possibilities:
    # If the child were the data is equal to our value is a leaf
      # then the child becomes nil instead, easy
    # If the child is not a leaf, check how many children he has
    # If he has one children, just skip the child in the tree
      # which means the child becomes the child child
    # If he has 2 children, find the next bigger and it becomes the child


  def deleting_nodes(node)
  end

  def delete(value, node=@root)
    if value == node.data # delete process
    return nil if node.left.is_leaf && node.right.is_leaf
    elsif value < node.data
      if value == node.left.data
        num_children = node.left.count_chidren
        case num_children
        when 0
          node.left = nil
        when 1
          node.left = node.left.left || node.left.right
        end
      else
        node = delete(value, node.left)
      end
    else
      if value == node.right.data
        num_children = node.right.count_chidren
        case num_children
        when 0
          node.right = nil
        when 1
          node.right = node.right.left || node.right.right
        end
      else
        delete(value, node.right)
      end
    end
    # deleting step
  end
end

extr_simple_arr = [8]
simple_array = [1, 2, 3, 4, 5, 6, 7]
data_arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
clean_data = data_arr.sort.uniq


my_simple_tree = Tree.new(simple_array)
my_complicated_tree = Tree.new(clean_data)


# my_complicated_tree.pretty_print
# my_complicated_tree.insert(68)
my_complicated_tree.pretty_print
p my_complicated_tree.find(23)
p my_complicated_tree.recursive_find(23)
puts my_complicated_tree.recursive_find(67)

p my_complicated_tree.delete(67)
p my_complicated_tree.pretty_print


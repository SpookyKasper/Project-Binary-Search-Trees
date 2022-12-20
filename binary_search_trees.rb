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

  def find_right_smallest(node, mama)
    mama = node
    current_node = node.right
    until node.left.nil?
      mama = current_node
      current_node = current_node.left
    end
    current_node
  end

  def delete_node(node, mama)
    case node.count_chidren
    when 0
      mama.data < node.data ? mama.right = nil : mama.left = nil
    when 1
      node.left.nil? ? mama.righ = node.right : mama.left = node.left
    when 2
      right_smallest = find_right_smallest(node)


    end
    result
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
        current_node = node.right
        mama = current_node
        until current_node.left.nil?
          mama = current_node
          current_node = current_node.left
        end
        if mama == current_node
          node.data = current_node.data
          node.right = current_node.right
          return
        end
        mama.left = delete(current_node.data, current_node, mama)
        node.data = current_node.data
        return
      end
    end
    value < node.data ? delete(value, node.left, node) : delete(value, node.right, node)
  end
end

simple_array = [1, 2, 3, 4, 5, 6, 7]
data_arr = [1, 7, 4, 23, 10, 12, 9, 4, 3, 5, 7, 9, 67, 6345, 324, 3234, 12338, 12, 234, 29, 98, 200, 245, 11]
clean_data = data_arr.sort.uniq

my_simple_tree = Tree.new(simple_array)
my_complicated_tree = Tree.new(clean_data)

# my_complicated_tree.insert(24)
# my_complicated_tree.insert(13)
# my_complicated_tree.pretty_print
my_complicated_tree.pretty_print
my_complicated_tree.delete(245)
my_complicated_tree.pretty_print
my_complicated_tree.delete(11)
my_complicated_tree.pretty_print
my_complicated_tree.delete(23)
my_complicated_tree.pretty_print
my_complicated_tree.delete(7)
my_complicated_tree.pretty_print

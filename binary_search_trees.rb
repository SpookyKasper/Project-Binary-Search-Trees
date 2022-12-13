class Node
  attr_accessor :left, :data, :right, :is_leaf

  def initialize(data, left=nil, right=nil)
    @data = data
    @left = left
    @right = right
    @is_leaf = @left.nil? && @right.nil?
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

  def find_leaf_for(value, root=@root)
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

  # Pseudo code for deleting single child tree
  # Given a value, look for that value in the tree as following
  # start at the root
    # if the root.data == nil return nil
    # if the root left child == value, 3 possibilities
      # the left child as no child
        # then the root left child becomes nil instead
      # the left child as one child
        # then the root left child becomes that child instead
      # the left child has 2 child
        # then make an array out of the left child node, remove the left child and build a tree
        # the root left child becomes that tree
    # if the root right child == value, same as above but with right
    # if the value is smaller than the root.data
    # root becomes the root left child
    # otherwise root becomes the root right child
  def find_next_bigger(value)
    return nil if find(value).right.nil?
    current_node = find(value).right
    until current_node.left.nil?
      current_node = current_node.left
    end
    current_node
  end

  def find(value)
    current_node = @root
    until current_node.data == value || current_node.is_leaf
      if value < current_node.data
        p 'goes left'
        current_node = current_node.left
      else
        p 'goes right'
        current_node = current_node.right
      end
    end
    current_node.data == value ? current_node : nil
  end
6
  def delete(value, node=@root)
    if value < node.data
      p 'goes left'
      if node.left.data == value
        if node.left.left.nil? && node.left.right.nil?
          node.left = nil
          return
        else
          node.left = build_tree(node.left)
          return
        end
      else
        delete(value, node.left)
      end
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


# my_simple_tree.delete(2)
my_simple_tree.pretty_print

p my_simple_tree.find(6)
my_complicated_tree.pretty_print
p my_complicated_tree.find_next_bigger(7)
p my_complicated_tree.find_next_bigger(67).data
p my_complicated_tree.find_next_bigger(8).data

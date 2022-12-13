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
  # Given a value look for that value in the Tree
  # If the value does not exit return nil
  # Otherwise scan the Tree until the right child root or left child root of a node is the value
  # Then there's 3 possibilities (or 6)
    # If the right child root data is equal to the value
      # and the right child root is a leaf, then it becomes nil
      # Same for the left child



  def delete(value, node=@root)
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


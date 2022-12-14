class Node
  include Comparable

  attr_accessor :left, :data, :right

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def count_children
    count = 0
    count += 1 unless @left.nil?
    count += 1 unless @right.nil?
    count
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
    return if array.empty?
    return Node.new(array[0]) if array.length < 2

    array = array.uniq.sort
    root_index = array.length / 2
    root = array[root_index]
    left = array[0..root_index - 1]
    right = array[root_index + 1..]
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

  def find(value, root = @root)
    return if root.nil?
    return root if root.data == value

    value < root.data ? find(value, root.left) : find(value, root.right)
  end

  def delete(value, root = @root, mama = @root)
    return if root.nil?
    delete_node(root, mama) and return value if value == root.data

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
      result << (block ? (yield current_node) : current_node.data)
      discovered_nodes.shift
    end
    result
  end

  def level_order_rec(result = [], discovered_nodes = [@root], &block)
    return result if discovered_nodes.empty?

    current_node = discovered_nodes[0]
    discovered_nodes << current_node.left unless current_node.left.nil?
    discovered_nodes << current_node.right unless current_node.right.nil?
    result << (block ? (yield current_node) : current_node.data)
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

  def depth(node, current_node = @root)
    return if node.nil?
    return 0 if node.data == current_node.data

    if node.data < current_node.data
      depth = 1 + depth(node, current_node.left)
    elsif node.data > current_node.data
      depth = 1 + depth(node, current_node.right)
    end
    depth
  end

  def height(node)
    return if node.nil?
    return 0 if node.left.nil? && node.right.nil?

    path_left = node.left ? 1 + height(node.left) : 0
    path_right = node.right ? 1 + height(node.right) : 0
    path_left >= path_right ? path_left : path_right
  end

  def balanced?(current_node = @root)
    return true if current_node.nil?
    return true if current_node.left.nil? && current_node.right.nil?

    left_subtree_height = height(current_node.left) || -1
    right_subtree_height = height(current_node.right) || -1
    diff = left_subtree_height - right_subtree_height
    return false if diff.abs > 1

    result_left = balanced?(current_node.left)
    return false unless result_left

    result_right = balanced?(current_node.right)
    return false unless result_right

    true
  end

  def rebalance
    return if balanced?

    array = inorder
    @root = build_tree(array)
  end
end

easy = [1, 2, 3, 5]
medium = [1, 2, 3, 4, 5, 6, 7, 8]
hardcore = [1, 7, 4, 24, 23, 10, 12, 9, 4, 3, 5, 7, 9, 67, 6345, 324, 3234, 12_338, 12, 234, 29, 98, 200, 245, 11]

easy_tree = Tree.new(easy)
medium_tree = Tree.new(medium)
hardcore_tree = Tree.new(hardcore)

new_binary_search_tree = Tree.new(Array.new(20) { rand(1..100) })
new_binary_search_tree.pretty_print
p new_binary_search_tree.balanced?
p new_binary_search_tree.level_order_rec
p new_binary_search_tree.preorder
p new_binary_search_tree.inorder
p new_binary_search_tree.postorder
new_binary_search_tree.insert(122)
new_binary_search_tree.insert(102)
new_binary_search_tree.insert(162)
new_binary_search_tree.pretty_print
p new_binary_search_tree.balanced?
new_binary_search_tree.rebalance
new_binary_search_tree.pretty_print
p new_binary_search_tree.balanced?
p new_binary_search_tree.level_order_rec
p new_binary_search_tree.preorder
p new_binary_search_tree.inorder
p new_binary_search_tree.postorder

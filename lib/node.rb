class Node
  attr_accessor :value, :next_node, :head, :tail

  def initialize(value)
    @value = value
    @next_node = nil
    @head = self
    @tail = self
  end

  def append(value)
    new_node = Node.new(value)
    if @head.nil?
      @head = new_node
      @tail = new_node
    else
      @tail.next_node = new_node
      @tail = new_node

    end
  end
end

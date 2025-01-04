require "rubocop"
require_relative "node"

class HashMap
  attr_accessor :bucket

  def initialize
    @load_factor = 0.8
    @capacity = 16
    @bucket = Array.new(@capacity, "")
    @head = nil
    @tail = nil
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = (prime_number * hash_code) + char.ord }

    hash_code
  end

  def set(key, value)
    index = hash(key) % 16
    if @bucket[index] == ""
      @bucket[index] = append([key, value]) # insert when empty
    elsif @bucket[index].value[0] == key
      @bucket[index].value[1] = value # update
    else
      @bucket[index].append([key, value]) # insert

    end
  end

  def append(value)
    @node = Node.new # remove
    @node.value = value
    if @head.nil?
      @head = @node
      @tail = @node
    else
      @node.next_node = @head
      @head = @node
    end
  end

  def get(key)
    index = hash(key) % 16
    @bucket[index].each do |node|
      return nil if node.nil? # check

      puts node.value[1] if node.value[0] == key
    end
  end

  def has?(key)
    index = hash(key) % 16
    @bucket[index].each do |node|
      return False if node.nil? # check

      return True if node.value[0] == key
    end
  end

  def remove(key)
    index = hash(key) % 16
    @bucket[index].each do |node|
      return False if node.nil?

      return True if node.value[0] == key
    end
  end
end

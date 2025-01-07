require "rubocop"
require_relative "node"

class HashMap
  attr_accessor :bucket
  attr_reader :count

  def initialize
    @load_factor = 0.8
    @capacity = 16
    @bucket = Array.new(@capacity, "")
    @head = nil
    @tail = nil
    @count = 0
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = (prime_number * hash_code) + char.ord }

    hash_code
  end

  def set(key, value)
    index = hash(key) % 16
    @count += 1
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
      return nil unless node.next_node.value[0] == key

      dummy = node.next_node
      node.next_node = dummy.next_node # jump between nodes
    end
  end

  def length
    @count # can be replaced with atrr reader
  end

  def clear
    @bucket = @bucket.map { |element| element = "" }
  end

  def keys
    keys_array = []
    @bucket.each do |entry|
      @bucket[entry].each do |node|
        return nil if node.nil? # try with and without

        keys_array.push(node.value[0])
      end
    end
  end

  def values
    keys_array = []
    @bucket.each do |entry|
      @bucket[entry].each do |node|
        return nil if node.nil? # try with and without

        keys_array.push(node.value[0])
      end
    end
  end
end

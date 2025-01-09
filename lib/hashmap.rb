require "rubocop"
require_relative "node"

class HashMap
  attr_accessor :bucket
  attr_reader :number_of_entries

  def initialize
    @bucket = Array.new(16, "")
    @load_factor = 0.8
    @capacity = @bucket.length
    @number_of_entries = 0
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = (prime_number * hash_code) + char.ord }

    hash_code
  end

  def set(key, value)
    grow_bucket
    index = hash(key) % @capacity
    if @bucket[index] == ""
      @bucket[index] = Node.new([key, value]) # insert when empty
    elsif has?(key)
      update(key, value) # update
    else
      @bucket[index].append([key, value]) # insert

    end
  end

  def update(key, value)
    @bucket.each do |entry|
      next if entry == ""

      entry.value[1] = value if entry.value[0] == key
      until entry.nil?
        entry.value[1] = value if entry.value[0] == key
        entry = entry.next_node
      end
    end
  end

  def grow_bucket
    grow = @capacity * @load_factor
    length
    if @number_of_entries > grow && @bucket.length >= 16
      dummy_bucket = Array.new(@bucket.length, '') # rubocop:disable Style/StringLiterals
      @bucket += dummy_bucket
    elsif @number_of_entries > grow
      dummy_bucket = Array.new(@bucket.length * 2, '') # rubocop:disable Style/StringLiterals
      @bucket += dummy_bucket
    end
  end

  def get(key)
    value_found = nil
    @bucket.each do |entry|
      next if entry == ""

      value_found = entry.value[1] if entry.value[0] == key

      until entry.nil? # loop trough nodes
        value_found = entry.value[1] if entry.value[0] == key
        entry = entry.next_node
      end
    end
    p value_found
  end

  def has?(key)
    exist = false
    @bucket.each do |entry|
      next if entry == ""

      exist = true if entry.value[0] == key

      until entry.nil? # loop trough nodes
        exist = true if entry.value[0] == key
        entry = entry.next_node
      end
    end
    exist
  end

  def remove(key) # too messy, improve and doesnt work
    entry_value = nil
    previous_node = nil
    @bucket.each do |entry|
      next if entry == ""

      @head = entry.next_node && break if entry.value[0] == key
      until entry.nil?
        previous_node.next_node = entry.next_node if entry.value[0] == key && !previous_node.nil?
        entry = entry.next_node
      end
      previous_node = entry
    end

    p entry_value
  end

  def length
    @number_of_entries = 0
    @bucket.each do |entry|
      next if entry == ""

      @number_of_entries += 1 if entry.instance_of?(Node)

      until entry.next_node.nil?
        @number_of_entries += 1
        entry = entry.next_node
      end
    end
    @number_of_entries
  end

  def clear
    @bucket = @bucket.map { |element| element = "" }
    @number_of_entries = 0
  end

  def keys
    array = []
    @bucket.each do |entry|
      return nil if entry.nil?

      next if entry == ""

      array << entry.value[0] if entry.instance_of?(Node)
      until entry.next_node.nil?
        array << entry.next_node.value[0]
        entry = entry.next_node
      end
    end
    p array
  end

  def values
    array = []
    @bucket.each do |entry|
      return nil if entry.nil?

      next if entry == ""

      array << entry.value[1] if entry.instance_of?(Node)
      until entry.next_node.nil?
        array << entry.next_node.value[1]
        entry = entry.next_node
      end
    end
    p array
  end

  def entries
    array = []
    @bucket.each do |entry|
      return nil if entry.nil?

      next if entry == ""

      array << entry.value if entry.instance_of?(Node)
      until entry.next_node.nil?
        array << entry.next_node.value
        entry = entry.next_node
      end
    end
    p array
  end
end

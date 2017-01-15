module Store
  def initialize(storage = nil)
    @id_counter = 1
    @store = storage
  end

  def self.not_implemented(method)
    raise NotImplementedError.new "method #{method} not implemented"
  end

  def self.hash_matches(tested, tester)
    match = true
    tester.each { |key, value| match &= tested[key] == value }
    match
  end

  def storage
    @store
  end

  def add_id_to_record(record)
    id = @id_counter
    @id_counter = id + 1
    record.merge({id: id})
  end

  def create
    Store.not_implemented "create"
  end

  def find
    Store.not_implemented "find"
  end

  def update
    Store.not_implemented "update"
  end

  def delete
    Store.not_implementedd "delete"
  end
end

class ArrayStore
  include Store

  def initialize
    super([])
  end

  def create(record)
    @store.push add_id_to_record(record)
  end

  def find(record)
    @store.select { |tested| Store.hash_matches tested, record }
  end

  def update(id, record)
    index = @store.index { |tested| tested[:id] == id }
    @store[index] = @store[index].merge record
  end

  def delete(record)
    @store.delete_if { |tested| Store.hash_matches tested, record }
  end
end

class HashStore
  include Store

  def initialize
    super {}
  end

  def create(record)
    record_with_id = add_id_to_record record
    @store[record_with_id[:id]] = record_with_id
  end

  def find(record)
    @store.select { |_, tested| Store.hash_matches tested, record }
  end

  def update(id, record)
    @store[id] = @store[id].merge record
  end

  def delete(record)
    @store.delete_if { |_, tested| Store.hash_matches tested, record }
  end
end

class DataModel
  class<<self
  attr_accessor :store_container, :attributes_container, :id

  def initialize(hash)
    hash.each { |key, value| instance_variable_set "@#{key}", value }
    @id = hash[:id]
  end

  def attributes(*attrs)
    return @attributes if attrs.empty?
    @attributes = attrs
    attrs.each do |attr|
      define_method("#{attr}=") { |val| instance_variable_set "@#{attr}", val }
      define_method(attr) { instance_variable_get "@#{attr}" }
      define_method("find_by_#{attr}") { |v| puts attr => v }
    end
  end

  def to_h
    hash = {}
    @@attributes.each { |attr| hash[attr] = instance_variable_get "@#{attr}" }
    hash
  end

  def save
    if @id == nil
      @store_container.create.to_h
    else
      @store_container.update
    end
  end

  def data_store(store_type)
    @store_container = store_type unless store_container.nil?
    @store_container
  end
  end
end

class User < DataModel
  attributes :first_name, :last_name
  data_store HashStore.new
  def initialize(hash_methods = {})
  end
end

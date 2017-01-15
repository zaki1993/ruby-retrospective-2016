class Hash
  def contains_key(key)
    if self.key?(key)
      self.fetch(key, nil)
    elsif self.key?(key.to_sym)
      self.fetch(key.to_sym, nil)
    end
  end

  def check_array(part, match)
    array_parts = part.split '.', 2
    if !array_parts[1] || match.nil?
      match[part.to_i]
    else
      match[array_parts[0].to_i].fetch_deep(array_parts[1])
    end
  end

  def check_hash(part, match)
    match.fetch_deep(part)
  end

  def fetch_deep(dotted_path = "")
    parts = dotted_path.split '.', 2
    if !parts[1] || contains_key(parts[0]).nil?
      contains_key(parts[0])
    elsif contains_key(parts[0]).is_a? Array
      check_array(parts[1], contains_key(parts[0]))
    elsif contains_key(parts[0]).is_a? Hash
      check_hash(parts[1], contains_key(parts[0]))
    end
  end

  def reshape(shape)
    shape.each do |key, value|
      if shape[key].is_a? Hash
        reshape(shape[key])
      else
        shape[key] = self.fetch_deep(value)
      end
    end
    shape
  end
end

class Array
  def split_arr(shape, hash, arr)
    self.size.times do |counter|
      shape.each do |key, value|
        hash[key] = self[counter].fetch_deep(value)
        arr << hash && hash = {} if hash.size == shape.size
      end
    end
  end

  def reshape(shape)
    arr = []
    hash = {}
    split_arr(shape, hash, arr)
    arr
  end
end

module Kernel

  def deep_clone(cache = {})
    return cache[self] if cache.key?(self)

    begin
      copy = clone
    rescue
      return cache[self] = self
    end

    cache[self] = copy

    copy.instance_variables.each do |name|
      begin
        var = instance_variable_get(name).deep_clone(cache)
        copy.instance_variable_set name, var
      rescue TypeError
      end
    end

    copy
  end

end

class Class

  def deep_clone(cache = {})
    self
  end

end

class Array

  def deep_clone(cache = {})
    return cache[self] if cache.key?(self)

    copy = super

    each_with_index do |value, index|
      copy[index] = value.deep_clone(cache)
    end

    copy
  end

end

class Hash

  def deep_clone(cache = {})
    return cache[self] if cache.key?(self)

    copy = super

    each do |key, value|
      copy[key] = value.deep_clone(cache)
    end

    copy
  end

end
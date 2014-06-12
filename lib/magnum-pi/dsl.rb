module MagnumPI
  class DSL < BasicObject

    def initialize(*valid_keys, &block)
      @valid_keys = valid_keys.collect &:to_sym
      instance_eval &block if ::Kernel.block_given?
    end

    def class
      (class << self; self end).superclass
    end

    def [](name)
      _values[name]
    end

    def slice(*keys)
      _values.slice *keys
    end

    def inspect
      _values.inspect
    end

    def to_hash
      _values.to_hash
    end

    def to_s
      _values.to_s
    end

    def deep_clone
      clone = self.class.new

      valid_keys = @valid_keys.deep_clone if @valid_keys
      values = @values.deep_clone if @values

      clone.instance_eval do
        @valid_keys = valid_keys
        @values = values
      end

      clone
    end

  private

    def _values
      @values ||= {}
    end

    def method_missing(name, *args, &block)
      process_value name, args, block
    end

    def process_value(name, value, block)
      set_value name, value
    end

    def set_value(name, value)
      unless @valid_keys.empty? || @valid_keys.include?(name)
        ::Kernel.raise ::ArgumentError, "Invalid key: '#{name}' (valid: #{@valid_keys.inspect})"
      end
      if error_message = value_error_message(name, value)
        ::Kernel.raise ::ArgumentError, "Invalid value for '#{name}': #{value.inspect} (#{error_message})"
      end
      _values[name] = value
    end

    def value_error_message(name, value)
      # override this method
    end

  end
end
module MagnumPI
  module API
    class Scheme < DSL

      def initialize
        super
        uri ::String
        format ::Symbol
      end

      def finalize(params = {})
        @types = (types = _types).dup
        @values = (values = _values).dup
        params.each do |name, value|
          process_value name, [value], nil
        end
        to_hash
      ensure
        @types = types
        @values = values
      end

    private

      def _types
        @types ||= {}
      end

      def process_value(name, args, block)
        is_a_class = (value = args[0]).class == ::Class
        set_type name, is_a_class ? value : value.class
        set_value name, value unless is_a_class
      end

      def set_type(name, type)
        _types[name] ||= type
      end

      def value_error_message(name, value)
        unless value.is_a?(type = _types[name])
          "expected #{type}"
        end
      end

    end
  end
end
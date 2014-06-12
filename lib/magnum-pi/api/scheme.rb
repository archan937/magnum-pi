module MagnumPI
  module API
    class Scheme < DSL

      def initialize
        super
        uri ::String
        format ::Symbol
      end

      def finalize(params = {})
        @types = (types = _types).deep_clone
        @values = (values = _values).deep_clone

        params.each do |name, value|
          process_value name, [value], nil
        end

        to_hash
      ensure
        @types = types
        @values = values
      end

      def deep_clone
        clone = super

        types = @types.deep_clone if @types

        clone.instance_eval do
          @types = types
        end

        clone
      end

    private

      def _types
        @types ||= {}
      end

      def process_value(name, args, block)
        value = args[0]
        if name == :resources
          (_values[name] ||= {}).merge! value
        else
          is_a_class = value.class == ::Class
          set_type name, is_a_class ? value : value.class
          set_value name, value unless is_a_class
        end
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
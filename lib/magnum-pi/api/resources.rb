module MagnumPI
  module API
    class Resources < DSL

      class Variable
        attr_accessor :name
      end

      def var(name)
        Variable.new.tap do |variable|
          variable.name = name
        end
      end

    end
  end
end
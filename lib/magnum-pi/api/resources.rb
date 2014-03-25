require "magnum-pi/api/resources/variable"

module MagnumPI
  module API
    class Resources < DSL

      def var(name)
        Variable.new.tap do |variable|
          variable.name = name
        end
      end

    end
  end
end
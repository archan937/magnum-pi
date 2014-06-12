module MagnumPI
  module API
    module Inheritance

      def inherited(base)
        base.instance_variable_set :@api, @api.deep_clone
        base.instance_variable_set :@resources, @resources.deep_clone
      end

    end
  end
end
module MagnumPI
  module API
    module Instance

      def initialize(params = {})
        super()
        @api = self.class.api.finalize params
        @resources = self.class.resources.to_hash
      end

      def api
        @api
      end

      def resources
        @resources
      end

    end
  end
end
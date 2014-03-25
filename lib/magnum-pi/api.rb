require "magnum-pi/api/scheme"
require "magnum-pi/api/resources"

module MagnumPI
  module API

    def api(&block)
      @api ||= Scheme.new
      if block_given?
        @api.instance_eval &block
      else
        @api
      end
    end

    def resources(&block)
      @resources ||= Resources.new
      if block_given?
        @resources.instance_eval &block
      else
        @resources
      end
    end

  end
end
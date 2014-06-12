require "magnum-pi/api/inheritance"
require "magnum-pi/api/scheme"
require "magnum-pi/api/resources"
require "magnum-pi/api/instance"
require "magnum-pi/api/consumer"

module MagnumPI
  module API

    def self.extended(base)
      if base.is_a? Class
        base.extend Inheritance
        base.send :include, Instance
        base.send :include, Consumer
      else
        base.extend Consumer
      end
    end

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
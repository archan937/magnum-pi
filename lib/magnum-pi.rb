require "mechanize"
require "oj"
require "xmlsimple"
require "active_support/core_ext/object/to_query"

require "magnum-pi/core_ext"
require "magnum-pi/gem_ext"
require "magnum-pi/dsl"
require "magnum-pi/api"
require "magnum-pi/version"

module MagnumPI

  def self.extended(base)
    base.extend API
  end

  def self.debug_output(bool = true)
    @debug_output = bool
  end

  def self.debug_output?
    !!@debug_output
  end

end
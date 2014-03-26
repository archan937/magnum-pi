require "mechanize"
require "oj"
require "xmlsimple"

require "magnum-pi/gem_ext"
require "magnum-pi/dsl"
require "magnum-pi/api"
require "magnum-pi/version"

module MagnumPI
  def self.extended(base)
    base.extend API
  end
end
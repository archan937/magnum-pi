require "bundler"
Bundler.require :default, :development

#
# Usage:
#
#   Vimeo.user_info "archan937"
#

module Vimeo
  extend MagnumPI

  api do
    uri "http://vimeo.com/api/v2"
    format :json
  end

  resources do
    user_info :get, var(:user), "info"
  end

private

  def self.to_url(*args)
    "#{super}/#{args.join("/")}.#{api[:format]}"
  end

  def self.to_params(url, *args)
    args[0].is_a?(Hash) ? args[0].slice(:page) : {}
  end

end
require "bundler"
Bundler.require :default, :development

#
# Usage:
#
#   Vimeo.get "archan937/info"
#   Vimeo.user_info "archan937"
#   Vimeo.user_info :user => "archan937"
#
#   Vimeo.download "archan937.json", :get, "archan937/info"
#   Vimeo.user_info ["archan937"], "archan937.json"
#   Vimeo.user_info({:user => "archan937"}, "archan937.json")
#
#   Vimeo.get "channel/ruby/videos"
#   Vimeo.channel_videos "ruby"
#   Vimeo.channel_videos ["ruby"], "ruby.json"
#

module Vimeo
  extend MagnumPI

  api do
    uri "http://vimeo.com/api/v2"
    format :json
  end

  resources do
    user_info :get, var(:user), "info"
    channel_videos :get, "channel", var(:channel), "videos"
  end

private

  def self.to_url(*args)
    "#{super}/#{args.join("/")}.#{api[:format]}"
  end

  def self.to_params(url, *args)
    args[0].is_a?(Hash) ? args[0].slice(:page) : {}
  end

end
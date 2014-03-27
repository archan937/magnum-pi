class Mechanize
  class Util

    def self.build_query_string(parameters, enc = nil)
      parameters = Hash[parameters] unless parameters.is_a?(Hash)
      parameters.to_query
    end

  end
end
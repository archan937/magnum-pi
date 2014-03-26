module MagnumPI
  module API
    module Consumer
      class Error < StandardError; end

      def get(*args)
        url, params = parse_args *args
        parse_content request(:get, url, params).content
      end

      def post(*args)
        url, params = parse_args *args
        parse_content request(:post, url, params).content
      end

      def download(target, method, *args)
        url, params = parse_args *args
        File.delete target if File.exists? target
        request(method, url, params).save_as target
        true
      end

      def resource(name, variables = {}, save_as = nil)
        args = parse_resource_variables(resources[name], variables)
        args = [:download, save_as].concat args if save_as
        send *args
      end

    private

      def method_missing(name, *args)
        resources[name.to_sym] ? resource(name, *args) : super
      end

      def request(method, url, params)
        puts "#{method.upcase} #{url} #{"(#{params.inspect[1..-2]})" if params && params.size > 0}" if MagnumPI.debug_output?
        agent.send method, url, params
      rescue Mechanize::ResponseCodeError => e
        raise Error, e.message, e.backtrace
      end

      def agent
        @agent ||= begin
          Mechanize.new.tap do |agent|
            agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
            agent.pluggable_parser.default = Mechanize::Download
          end
        end
      end

      def parse_args(*args)
        url = to_url(*args)
        [url, to_params(url, *args)]
      end

      def parse_resource_variables(resource, variables)
        variables = normalize_resource_variables resource, variables
        resource.collect do |arg|
          arg.is_a?(Resources::Variable) ? (variables[arg.name.to_s] || variables[arg.name.to_sym]) : arg
        end
      end

      def normalize_resource_variables(resource, variables)
        if !variables.is_a?(Hash) && (vars = resource.select{|x| x.is_a?(Resources::Variable)}).any?
          variables = [variables].flatten
          raise ArgumentError, "Unexpected amount of variables: #{variables.size} (expected: #{vars.size})" unless variables.size == vars.size
          variables = Hash[vars.collect(&:name).zip(variables)]
        end
        variables
      end

      def to_url(*args)
        api[:uri]
      end

      def to_params(url, *args)
        raise NotImplementedError
      end

      def parse_content(response)
        case api[:format].to_s
        when "json"
          Oj.load response
        when "xml"
          XmlSimple.xml_in response
        else
          response
        end
      end

    end
  end
end
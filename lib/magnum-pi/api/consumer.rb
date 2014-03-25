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
        args = resources[name].collect do |arg|
          arg.is_a?(Resources::Variable) ? variables[arg.name] : arg
        end
        args = [:download, save_as].concat args if save_as
        send *args
      end

    private

      def request(method, url, params)
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
require_relative "../../test_helper"

module Unit
  module API
    class TestConsumer < MiniTest::Test

      class Consumer
        include MagnumPI::API::Consumer
        def to_params(url, *args)
          args[0]
        end
      end

      class IncompleteConsumer
        include MagnumPI::API::Consumer
      end

      describe MagnumPI::API::Consumer do
        before do
          @consumer = Consumer.new
          @consumer.stubs(:api).returns(
            :uri => "http://foo.bar",
            :format => :json
          )
          @consumer.stubs(:resources).returns(
            :statistics => [:get, "stats", MagnumPI::API::Resources::Variable.new.tap{|var| var.name = :date}]
          )
        end
        describe "#get" do
          it "makes a GET request" do
            response = mock
            response.expects(:content).returns('{"name": "Paul Engel"}')
            @consumer.expects(:request).with(:get, "http://foo.bar", {:foo => "bar"}).returns(response)
            assert_equal({"name" => "Paul Engel"}, @consumer.get(:foo => "bar"))
          end
        end
        describe "#post" do
          it "makes a POST request" do
            response = mock
            response.expects(:content).returns('{"name": "Paul Engel"}')
            @consumer.expects(:request).with(:post, "http://foo.bar", {:foo => "bar"}).returns(response)
            assert_equal({"name" => "Paul Engel"}, @consumer.post(:foo => "bar"))
          end
        end
        describe "#download" do
          it "downloads using the Mechanize agent" do
            response = mock
            response.expects(:save_as).with("path/to/target")
            @consumer.expects(:request).with(:get, "http://foo.bar", :foo => "bar").returns(response)
            @consumer.download "path/to/target", :get, :foo => "bar"
          end
        end
        describe "#resource" do
          it "interpolates passed variables and makes a request" do
            @consumer.expects(:send).with(:get, "stats", "2014-03-20")
            @consumer.resource :statistics, :date => "2014-03-20"
          end
          it "interpolates passed variables and downloads a file" do
            @consumer.expects(:send).with(:download, "path/to/target", :get, "stats", "2014-03-20")
            @consumer.resource :statistics, {:date => "2014-03-20"}, "path/to/target"
          end
        end
        describe "#request" do
          it "is delegated to the Mechanize agent" do
            @consumer.send(:agent).expects(:send).with(:get, :foo, :bar)
            @consumer.send(:request, :get, :foo, :bar)
          end
          it "raises an error when a Mechanize::ResponseCodeError occurs" do
            agent = @consumer.send(:agent)
            def agent.send(*args)
              raise Mechanize::ResponseCodeError.new(Struct.new(:code).new)
            end
            assert_raises MagnumPI::API::Consumer::Error do
              @consumer.get
            end
          end
        end
        describe "#agent" do
          it "returns a memoized Mechanize agent" do
            assert_equal Mechanize, @consumer.send(:agent).class
            assert_equal @consumer.send(:agent).object_id, @consumer.send(:agent).object_id
          end
          it "is configured as expected" do
            assert_equal OpenSSL::SSL::VERIFY_NONE, @consumer.send(:agent).verify_mode
            assert_equal Mechanize::Download, @consumer.send(:agent).pluggable_parser.default
          end
        end
        describe "#parse_args" do
          it "derives the URL and params" do
            @consumer.expects(:to_url).with({:foo => "bar"}).returns("http://foo.bar")
            assert_equal ["http://foo.bar", {:foo => "bar"}], @consumer.send(:parse_args, {:foo => "bar"})
          end
        end
        describe "#to_url" do
          it "returns api[:uri]" do
            assert_equal "http://foo.bar", @consumer.send(:to_url)
          end
        end
        describe "#to_params" do
          it "raises a NotImplementedError" do
            assert_raises NotImplementedError do
              IncompleteConsumer.new.send :to_params, "url"
            end
          end
        end
        describe "#parse_content" do
          it "parses the passed content" do
            assert_equal(
              {
                "foo" => "bar"
              }, @consumer.send(:parse_content,
                <<-JSON
                  {"foo": "bar"}
                JSON
              )
            )
            @consumer.expects(:api).returns :format => "xml"
            assert_equal(
              {
                "bar" => ["BAR"],
                "baz" => [{"hello" => "world", "content" => "Baz!"}]
              }, @consumer.send(:parse_content,
                <<-XML
                  <xml>
                    <bar>BAR</bar>
                    <baz hello="world">Baz!</baz>
                  </xml>
                XML
              )
            )
            @consumer.expects(:api).returns :format => "unknown"
            assert_equal("foobar", @consumer.send(:parse_content, "foobar"))
          end
        end
      end

    end
  end
end
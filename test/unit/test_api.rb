require_relative "../test_helper"

module Unit
  class TestApi < MiniTest::Test

    class SomeAPI
      extend MagnumPI::API
    end

    describe MagnumPI::API do
      describe "when extended" do
        it "also extends base with MagnumPI::API::Instance" do
          assert_equal true, SomeAPI.included_modules.include?(MagnumPI::API::Instance)
        end
      end

      describe ".api" do
        describe "without block argument" do
          it "returns a MagnumPI::API::Scheme instance" do
            assert_equal MagnumPI::API::Scheme, SomeAPI.api.class
          end
        end
        describe "with block argument" do
          it "instance evaluates the passed block" do
            SomeAPI.api do
              hello "world"
            end
            assert_equal "world", SomeAPI.api[:hello]
          end
        end
      end

      describe ".resources" do
        describe "without block argument" do
          it "returns a MagnumPI::API::Resources instance" do
            assert_equal MagnumPI::API::Resources, SomeAPI.resources.class
          end
        end
        describe "with block argument" do
          it "instance evaluates the passed block" do
            SomeAPI.resources do
              foo "bar"
            end
            assert_equal ["bar"], SomeAPI.resources[:foo]
          end
        end
      end

      describe ".initialize" do
        before do
          SomeAPI.class_eval do
            @api = nil
            @resources = nil
          end
          SomeAPI.api do
            uri "http://awesome.com/api/v1"
            format :json
            api_key String
          end
          SomeAPI.resources do
            foo "bar"
          end
        end
        it "returns an instance with the finalized api config" do
          api = SomeAPI.new :api_key => "123456789"
          assert_equal({
            :uri => "http://awesome.com/api/v1",
            :format => :json,
            :api_key => "123456789"
          }, api.send(:api))
          assert_equal({
            :foo => ["bar"]
          }, api.send(:resources))
        end
      end
    end

  end
end
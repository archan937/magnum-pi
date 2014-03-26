require_relative "../test_helper"

module Unit
  class TestApi < MiniTest::Test

    class SomeAPI
      extend MagnumPI::API
    end

    module SomeOtherAPI
      extend MagnumPI::API
    end

    describe MagnumPI::API do
      describe "when extending a class" do
        it "also includes MagnumPI::API::Instance within the class" do
          assert_equal true, SomeAPI.included_modules.include?(MagnumPI::API::Instance)
        end
        it "also includes MagnumPI::API::Consumer within the class" do
          assert_equal true, SomeAPI.included_modules.include?(MagnumPI::API::Consumer)
        end
      end

      describe "when extending a module" do
        it "also extends the module with MagnumPI::API::Consumer" do
          assert_equal true, (class << SomeOtherAPI; self end).included_modules.include?(MagnumPI::API::Consumer)
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
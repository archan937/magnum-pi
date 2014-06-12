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

    class FooAPI
      extend MagnumPI::API
      api do
        uri String
        format :xml
        api_key String
        resources({
          "foo/Bars" => {
            :params => {
              :start_date => Date,
              :end_date => Date
            }
          }
        })
      end
      resources do
        bars :get, "foo/Bars", {:start_date => Date.today}
      end
    end

    class BarAPI < FooAPI
      api do
        resources({
          "baz/Quxs" => {}
        })
      end
      resources do
        quxs :get, "baz/Quxs"
      end
    end

    describe "inheritance" do
      describe ".api" do
        it "inherits the API definition of its parent" do
          assert BarAPI.api != nil
          assert BarAPI.api.__id__ != FooAPI.api.__id__
          assert_equal FooAPI.api.to_hash.tap{|h| h[:resources].merge!("baz/Quxs" => {})}, BarAPI.api.to_hash
        end
      end
      describe ".resources" do
        it "inherits the resources definition of its parent" do
          assert BarAPI.resources != nil
          assert BarAPI.resources.__id__ != FooAPI.resources.__id__
          assert_equal FooAPI.resources.to_hash.merge(:quxs => [:get, "baz/Quxs"]), BarAPI.resources.to_hash
        end
      end
    end

  end
end
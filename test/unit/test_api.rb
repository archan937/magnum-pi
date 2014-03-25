require_relative "../test_helper"

module Unit
  class TestApi < MiniTest::Test

    class SomeAPI
      extend MagnumPI::API
    end

    describe MagnumPI::API do
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
    end

  end
end
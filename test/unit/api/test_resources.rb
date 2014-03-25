require_relative "../../test_helper"

module Unit
  module API
    class TestResources < MiniTest::Test

      describe MagnumPI::API::Resources do
        describe ".var" do
          it "returns a MagnumPI::API::Resources::Variable instance" do
            variable = MagnumPI::API::Resources.new.var("foo")
            assert_equal MagnumPI::API::Resources::Variable, variable.class
            assert_equal "foo", variable.name
          end
        end
      end

    end
  end
end
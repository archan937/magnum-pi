require_relative "../../test_helper"

module Unit
  module CoreExt
    class TestDeepClone < MiniTest::Test

      describe "#deep_clone" do
        it "returns a deep clone of the instance" do
          array = [1, 2, 3]
          array.instance_variable_set :@array, %w(4 5 6)

          instance = {
            :a => array,
            :b => "Hello",
            :c => {
              "alpha" => [4, 5],
              "beta" => [5, 6]
            }
          }

          clone = instance.deep_clone
          assert_equal instance, clone
          assert_equal instance[:a].instance_variable_get(:@array), clone[:a].instance_variable_get(:@array)

          clone.merge! :d => [1, 2, 3]
          assert_equal [:a, :b, :c], instance.keys
          assert_equal [:a, :b, :c, :d], clone.keys
          assert_equal [1, 2, 3], clone[:d]
          assert_equal instance, clone.reject{|k, v| k == :d}

          clone[:a].instance_variable_get(:@array) << "7"
          assert_equal %w(4 5 6), instance[:a].instance_variable_get(:@array)
          assert_equal %w(4 5 6 7), clone[:a].instance_variable_get(:@array)

          clone[:a] << 4
          assert_equal [1, 2, 3], instance[:a]
          assert_equal [1, 2, 3, 4], clone[:a]
        end
      end

    end
  end
end
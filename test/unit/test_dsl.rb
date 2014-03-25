require_relative "../test_helper"

module Unit
  class TestDSL < MiniTest::Test

    describe MagnumPI::DSL do
      describe "#initialize" do
        it "stores passed valid keys" do
          dsl = MagnumPI::DSL.new "foo", "bar"
          assert_equal [:foo, :bar], dsl.instance_eval("@valid_keys")
        end

        it "instance evaluates a passed block" do
          MagnumPI::DSL.any_instance.expects(:foo).with("bar")
          MagnumPI::DSL.new do
            foo "bar"
          end
        end
      end

      before do
        @dsl = MagnumPI::DSL.new
      end

      describe "#class" do
        it "returns MagnumPI::DSL" do
          assert_equal MagnumPI::DSL, @dsl.class
        end
      end

      describe "#_values" do
        it "is an internal memoized hash" do
          assert_equal true, @dsl.instance_eval("_values").is_a?(Hash)
          assert_equal @dsl.instance_eval("_values").object_id, @dsl.instance_eval("_values").object_id
        end
      end

      describe "#[]" do
        it "is delegated to values" do
          @dsl.instance_eval("_values").expects(:[]).with("foo")
          @dsl["foo"]
        end
      end

      describe "#slice" do
        it "is delegated to values" do
          @dsl.instance_eval("_values").expects(:slice).with("foo", "bar")
          @dsl.slice "foo", "bar"
        end
      end

      describe "#inspect" do
        it "is delegated to values" do
          @dsl.instance_eval("_values").expects(:inspect)
          @dsl.inspect
        end
      end

      describe "#to_hash" do
        it "is delegated to values" do
          @dsl.instance_eval("_values").expects(:to_hash)
          @dsl.to_hash
        end
      end

      describe "#to_s" do
        it "is delegated to values" do
          @dsl.instance_eval("_values").expects(:to_s)
          @dsl.to_s
        end
      end

      describe "#method_missing" do
        it "functions as a setter for its internal hash" do
          assert_equal({}, @dsl.instance_eval("_values"))
          @dsl.foo "bar"
          @dsl.hello do; end
          assert_equal({:foo => ["bar"], :hello => []}, @dsl.instance_eval("_values"))
        end
      end
    end

    describe "validation" do
      class DSL < MagnumPI::DSL
      private
        def value_error_message(name, value)
          "BOOM!!"
        end
      end

      it "raises an error when using an invalid key" do
        dsl = MagnumPI::DSL.new :foo, "bar"
        dsl.foo
        dsl.bar
        assert_raises ArgumentError do
          dsl.baz
        end
      end

      it "can validate the passed value" do
        assert_equal "Invalid value for 'foo': [] (BOOM!!)", assert_raises(ArgumentError){ DSL.new.foo }.message
      end
    end

  end
end
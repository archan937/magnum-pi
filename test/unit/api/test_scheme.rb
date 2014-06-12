require_relative "../../test_helper"

module Unit
  module API
    class TestScheme < MiniTest::Test

      describe MagnumPI::API::Scheme do
        before do
          @scheme = MagnumPI::API::Scheme.new
        end

        describe "#initialize" do
          it "presets `uri` and `format`" do
            assert_equal({:uri => String, :format => Symbol}, @scheme.instance_eval("_types"))
          end
        end

        describe "#class" do
          it "returns MagnumPI::API::Scheme" do
            assert_equal MagnumPI::API::Scheme, @scheme.class
          end
        end

        describe "#finalize" do
          it "foo" do
            @scheme.foo String
            @scheme.bar :baz => "qux"
            object_id = @scheme.instance_eval("_values").object_id

            assert_equal({:bar => {:baz => "qux"}}, @scheme.finalize)
            assert_equal({:foo => "foo", :bar => {:baz => "qux"}}, @scheme.finalize(:foo => "foo"))
            assert_equal object_id, @scheme.instance_eval("_values").object_id
            assert_equal({:foo => "FOO", :bar => {:baz => "qux"}}, @scheme.finalize(:foo => "FOO"))

            finalized = @scheme.finalize :foo => "foo"
            assert_equal({:bar => {:baz => "qux"}}, @scheme.instance_eval("_values"))

            finalized[:bar][:baz] = "QUX"
            assert_equal({:bar => {:baz => "qux"}}, @scheme.instance_eval("_values"))

            assert_raises ArgumentError do
              @scheme.finalize :foo => :foo
            end
          end
        end

        describe "#_types" do
          it "is an internal memoized hash" do
            assert_equal true, @scheme.instance_eval("_types").is_a?(Hash)
            assert_equal @scheme.instance_eval("_types").object_id, @scheme.instance_eval("_types").object_id
          end
        end

        describe "types" do
          describe "defining" do
            it "can only be done once" do
              assert_equal({:uri => String, :format => Symbol}, @scheme.instance_eval("_types"))
              @scheme.format String
              assert_equal({:uri => String, :format => Symbol}, @scheme.instance_eval("_types"))
              @scheme.foo String
              assert_equal({:uri => String, :format => Symbol, :foo => String}, @scheme.instance_eval("_types"))
              @scheme.foo Symbol
              assert_equal({:uri => String, :format => Symbol, :foo => String}, @scheme.instance_eval("_types"))
            end
          end
          describe "validating" do
            describe "when setting a valid value" do
              it "allows value to be set" do
                assert_equal({}, @scheme.instance_eval("_values"))
                @scheme.format :json
                assert_equal({:format => :json}, @scheme.instance_eval("_values"))
                @scheme.format :xml
                assert_equal({:format => :xml}, @scheme.instance_eval("_values"))
              end
            end
            describe "when setting an invalid value" do
              it "raises an error" do
                assert_equal "Invalid value for 'format': \"json\" (expected Symbol)", assert_raises(ArgumentError){ @scheme.format "json" }.message
              end
            end
          end
        end
      end

    end
  end
end
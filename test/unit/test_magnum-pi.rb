require_relative "../test_helper"

module Unit
  class TestMagnumPI < MiniTest::Test

    class SomeAPI
      extend MagnumPI
    end

    describe MagnumPI do
      it "has the current version" do
        version = File.read(path("VERSION")).strip
        assert_equal version, MagnumPI::VERSION
        assert File.read(path "CHANGELOG.rdoc").include?("Version #{version}")
      end

      describe "when extended" do
        it "also extends base with MagnumPI::API::Consumer" do
          def SomeAPI.extended_modules
            (class << self; self end).included_modules
          end
          assert_equal true, SomeAPI.extended_modules.include?(MagnumPI::API)
        end
      end

      describe ".debug_output" do
        before do
          MagnumPI.class_eval do
            @debug_output = nil
          end
        end
        describe "when not passing an argument" do
          it "sets to true" do
            MagnumPI.debug_output
            assert_equal true, MagnumPI.class_eval("@debug_output")
          end
        end
        describe "when passing an argument" do
          it "stores the passed argument" do
            MagnumPI.debug_output false
            assert_equal false, MagnumPI.class_eval("@debug_output")
            MagnumPI.debug_output "foo"
            assert_equal "foo", MagnumPI.class_eval("@debug_output")
          end
        end
      end

      describe ".debug_output?" do
        before do
          MagnumPI.class_eval do
            @debug_output = nil
          end
        end
        describe "when not set" do
          it "returns false" do
            assert_equal false, MagnumPI.debug_output?
          end
        end
        describe "when setting a falsy value" do
          it "returns false" do
            MagnumPI.debug_output false
            assert_equal false, MagnumPI.debug_output?
            MagnumPI.debug_output true
            assert_equal true, MagnumPI.debug_output?
            MagnumPI.debug_output nil
            assert_equal false, MagnumPI.debug_output?
          end
        end
        describe "when setting a truthy value" do
          it "returns true" do
            MagnumPI.debug_output true
            assert_equal true, MagnumPI.debug_output?
            MagnumPI.debug_output false
            assert_equal false, MagnumPI.debug_output?
            MagnumPI.debug_output "foo"
            assert_equal true, MagnumPI.debug_output?
          end
        end
      end
    end

  end
end
require_relative "../test_helper"

module Unit
  class TestMagnumPI < MiniTest::Test

    class SomeAPI
      extend MagnumPI
    end

    describe MagnumPI do
      it "has the current version" do
        version = "0.1.0"
        assert_equal version, MagnumPI::VERSION
        assert File.read(path "CHANGELOG.rdoc").include?("Version #{version}")
        assert File.read(path "VERSION").include?(version)
      end

      describe "when extended" do
        it "also extends base with MagnumPI::API::Consumer" do
          def SomeAPI.extended_modules
            (class << self; self end).included_modules
          end
          assert_equal true, SomeAPI.extended_modules.include?(MagnumPI::API)
        end
      end
    end

  end
end
require_relative "../test_helper"

module Unit
  class TestMagnumPI < MiniTest::Test

    describe MagnumPI do
      it "has the current version" do
        version = "0.1.0"
        assert_equal version, MagnumPI::VERSION
        assert File.read(path "CHANGELOG.rdoc").include?("Version #{version}")
        assert File.read(path "VERSION").include?(version)
      end
    end

  end
end
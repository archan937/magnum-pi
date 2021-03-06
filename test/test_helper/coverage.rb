if Dir.pwd == File.expand_path("../../..", __FILE__)
  require "simplecov"
  SimpleCov.coverage_dir "test/coverage"
  SimpleCov.start do
    add_group "MagnumPI", "lib"
    add_group "Test suite", "test"
    add_filter do |src|
      src.filename.include?("gem_ext/mechanize")
    end
  end
end
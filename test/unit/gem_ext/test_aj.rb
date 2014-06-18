require_relative "../../test_helper"

module Unit
  class TestAj < MiniTest::Test

    describe Aj do
      before do
        @json = <<-JSON
          {
            "data": {
              "articles": [
                {
                  "title": "MagnumPI is awesome!!!",
                  "category": "ruby"
                }, {
                  "title": "Netherlands beats Spain with 1-5 :)",
                  "category": "sport"
                }
              ]
            }
          }
        JSON
      end
      it "parses JSON like Oj" do
        assert_equal Oj.load(@json), Aj.new(@json).to_enum
        assert_equal({
          "data" => {
            "articles" => [
              {
                "title" => "MagnumPI is awesome!!!",
                "category" => "ruby"
              }, {
                "title" => "Netherlands beats Spain with 1-5 :)",
                "category" => "sport"
              }
            ]
          }
        }, Aj.new(@json).to_enum)
        assert_equal({
          "name" => "Paul Engel"
        }, Aj.new('{"name": "Paul Engel"}').to_enum)
        assert_equal([
          {"name" => "Paul Engel"},
          {"name" => "Ken Adams"}
        ], Aj.new('[{"name": "Paul Engel"}, {"name": "Ken Adams"}]').to_enum)
      end
      it "can return an array within a JSON document" do
        result = []
        Aj.new(@json).each("data/articles") do |entry|
          result << entry
        end
        assert_equal [
          [
            {
              "title" => "MagnumPI is awesome!!!",
              "category" => "ruby"
            }, {
              "title" => "Netherlands beats Spain with 1-5 :)",
              "category" => "sport"
            }
          ]
        ], result
      end
      it "can iterate through a JSON document" do
        articles = []
        Aj.new(@json).each("data/articles/*") do |article|
          articles << article
        end
        assert_equal [
          {
            "title" => "MagnumPI is awesome!!!",
            "category" => "ruby"
          }, {
            "title" => "Netherlands beats Spain with 1-5 :)",
            "category" => "sport"
          }
        ], articles
      end
    end

  end
end
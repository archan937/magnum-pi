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

        json = '{"name": "Paul Engel"}'
        assert_equal Oj.load(json), Aj.new(json).to_enum
        assert_equal({
          "name" => "Paul Engel"
        }, Aj.new(json).to_enum)

        json = '[{"name": "Paul Engel"}, {"name": "Ken Adams"}]'
        assert_equal Oj.load(json), Aj.new(json).to_enum
        assert_equal([
          {"name" => "Paul Engel"},
          {"name" => "Ken Adams"}
        ], Aj.new(json).to_enum)

        json = '{"name": "Paul Engel", "foo": {"00": {"bar": "baz"}}}'
        assert_equal Oj.load(json), Aj.new(json).to_enum
        assert_equal({
          "name" => "Paul Engel",
          "foo" => {
            "00" => {
              "bar" => "baz"
            }
          }
        }, Aj.new(json).to_enum)

        json = <<-JSON
          {
            "timezone": "Europe/Amsterdam",
            "offset": "+02:00",
            "date": "2014-03-20",
            "stats": {
              "00": {
                "foo": 1234567890,
                "bar": 123.45,
                "baz": 543.21
              },
              "01": {
                "foo": 9876543210
              }
            }
          }
        JSON
        assert_equal Oj.load(json), Aj.new(json).to_enum
        assert_equal({
          "timezone" => "Europe/Amsterdam",
          "offset" => "+02:00",
          "date" => "2014-03-20",
          "stats" => {
            "00" => {
              "foo" => 1234567890,
              "bar" => 123.45,
              "baz" => 543.21
            },
            "01" => {
              "foo" => 9876543210
            }
          }
        }, Aj.new(json).to_enum)
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
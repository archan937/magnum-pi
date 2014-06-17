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
        }, Aj.new(@json).to_hash)
      end
      it "can iterate through an XML document" do
        articles = []
        Aj.new(@json).each("data/articles") do |article|
          articles << article
        end
        assert_equal [
          {
            "title" => ["MagnumPI is awesome!!!"],
            "category" => ["ruby"]
          }, {
            "title" => ["Netherlands beats Spain with 1-5 :)"],
            "category" => ["sport"]
          }
        ], articles
      end
    end

  end
end
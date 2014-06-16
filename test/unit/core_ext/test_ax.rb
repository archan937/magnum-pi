require_relative "../../test_helper"

module Unit
  class TestAx < MiniTest::Test

    describe Ax do
      before do
        @xml = <<-XML
          <?xml version="1.0" encoding="utf-8"?>
          <response>
            <data>
              <article>
                <title>MagnumPI is awesome!!!</title>
                <category>ruby</category>
              </article>
              <article>
                <title>Netherlands beats Spain with 1-5 :)</title>
                <category>sport</category>
              </article>
            </data>
          </response>
        XML
      end
      it "parses XML like XmlSimple" do
        assert_equal({
          "data" => [{
            "article" => [
              {
                "title" => ["MagnumPI is awesome!!!"],
                "category" => ["ruby"]
              }, {
                "title" => ["Netherlands beats Spain with 1-5 :)"],
                "category" => ["sport"]
              }
            ]
          }]
        }, Ax.new(@xml).to_hash)
      end
      it "can iterate through an XML document" do
        articles = []
        Ax.new(@xml).each("/*/article") do |article|
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
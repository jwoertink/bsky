module Bsky
  class FacetLink < Facet
    def initialize(@byte_start : Int32, @byte_end : Int32, @url : String)
    end

    def to_h
      {
        "index" => {
          "byteStart" => @byte_start,
          "byteEnd" => @byte_end
        },
        "features" => [
          {
            "$type": "app.bsky.richtext.facet#link",
            "uri": @url
          }
        ]
      }
    end
  end
end

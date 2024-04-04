module Bsky
  class FacetMention < Facet
    def initialize(@byte_start : Int32, @byte_end : Int32, @did : String)
    end

    def to_h
      {
        "index" => {
          "byteStart" => @byte_start,
          "byteEnd" => @byte_end
        },
        "features" => [
          {
            "$type": "app.bsky.richtext.facet#mention",
            "did": @did
          }
        ]
      }
    end
  end
end

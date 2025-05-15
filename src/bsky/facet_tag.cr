module Bsky
  class FacetTag < Facet
    def initialize(@byte_start : Int32, @byte_end : Int32, @tag : String)
    end

    def to_h
      {
        "index" => {
          "byteStart" => @byte_start,
          "byteEnd"   => @byte_end,
        },
        "features" => [
          {
            "$type" => "app.bsky.richtext.facet#tag",
            "tag"   => @tag,
          },
        ],
      }
    end
  end
end
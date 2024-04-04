module Bsky
  class Image
    def initialize(
      @ref : String,
      @mime_type : String,
      @size : Int64,
      @alt : String? = nil
    )
    end

    def to_h
      {
        "alt"   => @alt || "Image",
        "image" => {
          "$type" => "blob",
          "ref"   => {
            "$link" => @ref,
          },
          "mimeType" => @mime_type,
          "size"     => @size,
        },
      }
    end
  end
end

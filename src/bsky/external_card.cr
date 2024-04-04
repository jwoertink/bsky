module Bsky
  class ExternalCard < Embed
    def initialize(
      @uri : String,
      @title : String,
      @description : String
      @thumb : Image? = nil
    )
    end

    def to_h
      {
        "$type" => "app.bsky.embed.external",
        "external" => {
          "uri" => @uri,
          "title" => @title,
          "description" => @description,
          "thumb" => @thumb.try(&.to_h)
        }
      }
    end
  end
end

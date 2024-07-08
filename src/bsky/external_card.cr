module Bsky
  class ExternalCard < Embed
    def initialize(
      @uri : String,
      @title : String,
      @description : String,
      @thumb : Image? = nil
    )
    end

    def to_h
      base = {
        "$type"    => "app.bsky.embed.external",
        "external" => {
          "uri"         => @uri,
          "title"       => @title,
          "description" => @description,
        },
      }

      @thumb.try do |thumb|
        if image = thumb.to_h["image"]?
          base = base.as(Hash).merge({
            "external" => {
              "thumb" => image,
            },
          })
        end
      end

      base
    end
  end
end

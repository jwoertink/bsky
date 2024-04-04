module Bsky
  class RichText
    @text : String
    @embed : Embed? = nil

    def initialize(@text : String)
      @facets = [] of Facet
    end

    def add_mention(mention_text : String, did : String)
      /#{mention_text}/.match(@text).try do |match|
        @facets << FacetMention.new(match.byte_begin, match.byte_end, did)
      end
    end

    def add_link(url : String)
      /#{url}/.match(@text).try do |match|
        @facets << FacetLink.new(match.byte_begin, match.byte_end, url)
      end
    end

    def embed_external(card : ExternalCard)
      @embed = card
    end

    def to_h
      base = {
        "$type"     => "app.bsky.feed.post",
        "text"      => @text,
        "createdAt" => Time.utc.to_rfc3339,
      }

      if em = @embed
        base = base.as(Hash).merge({
          "embed" => em.to_h,
        })
      end

      if !@facets.empty?
        base = base.as(Hash).merge({
          "facets" => @facets.map(&.to_h),
        })
      end

      base
    end
  end
end

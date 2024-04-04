module Bsky
  class RichText
    @text : String
    @embed : Embed? = nil

    def initialize(@text : String)
      @facets = [] of Facet
    end

    def set_mention(mention_text : String, did : String)
      /#{mention_text}/.match(@text).try do |m|
      @facets << FacetMention.new(m.byte_begin, m.byte_end, did)
      end
    end

    def set_link(url : String)
      /#{url}/.match(@text).try do |m|
        @facets << FacetLink.new(m.byte_begin, m.byte_end, url)
      end
    end

    def embed_external(card : ExternalCard)
      @embed = card
    end

    def to_h
      base = {
        "$type" => "app.bsky.feed.post",
        "text" => @text,
        "createdAt" => Time.utc.to_rfc3339
      }

      if em = @embed
        base.as(Hash).merge({
          "embed" => em.to_h
        })
      end

      if !@facets.empty?
        base.as(Hash).merge({
          "facets" => @facets.map(&.to_h)
        })
      end

      base
    end
  end
end

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

    def extract_tags
      regex = /
        \#(
          (?:\#{1,2}(?!\d+$)[a-zA-Z0-9_]{1,64}) |                     # Double # and non-numeric
          (?:
            (?:[\x{1F3FB}-\x{1F3FF}])?                                # optional skin tone
              (?:[\x{1F1E6}-\x{1F1FF}]{2} |                           # flags
                [\x{1F300}-\x{1FAFF}\x{2600}-\x{26FF}\x{2700}-\x{27BF}]
                (?:\x{200D}[\x{1F300}-\x{1FAFF}\x{2600}-\x{26FF}\x{2700}-\x{27BF}])*
                [\x{FE0F}]?                                            # emoji presentation
              )+
          ) |
          (?!\d+$)[\p{L}\p{M}\p{N}+\=\|\>\<]{2,64}                    # mixed unicode (not only digits)
        )
      /x

      @text.scan(regex) do |match|
        @facets << FacetTag.new(match.byte_begin, match.byte_end, match[1])
      end
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

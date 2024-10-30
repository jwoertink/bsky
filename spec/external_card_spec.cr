require "./spec_helper"

describe Bsky::ExternalCard do
  context "with an image" do
    it "adds the thumb key" do
      img = Bsky::Image.new("ref:123", "image/jpg", 100)
      card = Bsky::ExternalCard.new("www.site.com", "My Site", "Welcome to my site", img)

      card.to_h["$type"].should eq("app.bsky.embed.external")
      card.to_h.dig("external", "uri").should eq("www.site.com")
      card.to_h.dig("external", "title").should eq("My Site")
      card.to_h.dig("external", "description").should eq("Welcome to my site")
      card.to_h.dig("external", "thumb", "ref", "$link").should eq("ref:123")
    end
  end

  context "without an image" do
    it "skips the thumb key" do
      card = Bsky::ExternalCard.new("www.site.com", "My Site", "Welcome to my site")

      card.to_h["$type"].should eq("app.bsky.embed.external")
      card.to_h.dig("external", "uri").should eq("www.site.com")
      card.to_h.dig("external", "title").should eq("My Site")
      card.to_h.dig("external", "description").should eq("Welcome to my site")
      card.to_h["external"].as(Hash).has_key?("thumb").should eq(false)
    end
  end
end

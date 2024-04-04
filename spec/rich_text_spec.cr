require "./spec_helper"

describe Bsky::RichText do
  context "a simple post" do
    it "builds" do
      text = Bsky::RichText.new("hello world")
      text.to_h["text"].should eq("hello world")
      text.to_h.keys.should eq(["$type", "text", "createdAt"])
    end
  end

  context "with a mention" do
    it "builds" do
      text = Bsky::RichText.new("Hello 🚀 @test.bsky.social")
      text.add_mention("@test.bsky.social", "did:abc:123")
      text.to_h.has_key?("facets").should eq(true)

      facet = text.to_h["facets"][0].as(Hash)
      facet.keys.should eq(["index", "features"])
      facet["index"].as(Hash)["byteStart"].should eq(11)
      facet["index"].as(Hash)["byteEnd"].should eq(28)
    end
  end
end

# Bsky (Atproto)

This is an API wrapper for [BlueSky Social](https://docs.bsky.app/)


## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     bsky:
       github: jwoertink/bsky
   ```

2. Run `shards install`

## Usage

```crystal
require "bsky"

client = Bsky::Client.new
client.login("my.handle.social", "my-app-pass-word")

# send a simple post
client.send_post("Posting from the API")

complex_post = Bsky::RichText.new("A complex post for @crystal.bsky.social https://crystal-lang.org #programming")

complex_post.add_mention("@crystal.bsky.social", did: "did:plc:abc123")
complex_post.add_link("https://crystal-lang.org")

# connect the hashtags
complex_post.extract_tags

image_data = File.read("./images/crystal.png")
image = client.upload_image(image_data, mime_type: "image/png", alt: "A nice Crystal")

external_card = Bsky::ExternalCard.new(
  uri: "https://crystal-lang.org",
  title: "The Crystal Programming Language",
  description: "A language for computers and humans!",
  thumb: image
)
complex_post.embed_external(external_card)

# complex_post.embed_images([image])

client.send_post(complex_post)

client.logout
```

## Development

* write code
* write spec
* crystal tool format spec/ src/
* ./bin/ameba
* crystal spec
* repeat

## Contributing

1. Fork it (<https://github.com/jwoertink/bsky/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Jeremy Woertink](https://github.com/jwoertink) - creator and maintainer

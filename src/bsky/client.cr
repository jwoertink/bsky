module Bsky
  class Client
    BASE_URL = "https://bsky.social/xrpc"

    getter access_token : String? = nil
    getter refresh_token : String? = nil
    getter did : String? = nil
    getter identifier : String? = nil

    # Create an "App Password" https://bsky.app/settings/app-passwords
    # `identifier` should be your login (e.g. myname.bsky.social)
    def login(@identifier : String, password : String) : JSON::Any
      headers = HTTP::Headers{"Content-Type" => "application/json", "Accept" => "application/json"}
      credentials = {"identifier" => @identifier, "password" => password}
      response = exec_post("/com.atproto.server.createSession", headers, login.to_json)
      data = JSON.parse(response.body.to_s)

      if response.status_code == 200
        @access_token = data["accessJwt"].as_s
        @refresh_token = data["refreshJwtn"].as_s
        @did = data["did"].as_s
      end

      data
    end

    def logout : Nil
      headers = HTTP::Headers{"Content-Type" => "application/json", "Accept" => "application/json", "Authorization" => "Bearer #{access_token}"}
      exec_post("/com.atproto.server.deleteSession", headers)
      @access_token = nil
      @refresh_token = nil
      @did = nil
    end

    def upload_image(image_data : String, mime_type : String, alt : String? = nil)
      headers = HTTP::Headers{"Content-Type" => mime_type, "Accept" => "application/json", "Authorization" => "Bearer #{access_token}"}
      response = exec_post("/com.atproto.repo.uploadBlob", headers, image_data)
      if response.status_code == 200
        data = JSON.parse(response.body.to_s)["blob"]
        Image.new(data)
      end
    end

    def send_post(plain_text : String)
      text = RichText.new(plain_text)
      send_post(text)
    end

    def send_post(text : RichText)
      post = {
        "repo" => @identifier,
        "collection" => "app.bsky.feed.post",
        "record" => text.to_h
      }
      headers = HTTP::Headers{"Content-Type" => "application/json", "Accept" => "application/json", "Authorization" => "Bearer #{access_token}"}
      response = exec_post("/com.atproto.repo.createRecord", headers, post.to_json)
      JSON.parse(response.body.to_s)
    end

    private def exec_post(path : String, headers : HTTP::Headers, body : String? = nil) : HTTP::Response
      HTTP::Client.post("#{BASE_URL}#{path}", headers, body: body)
    end
  end
end

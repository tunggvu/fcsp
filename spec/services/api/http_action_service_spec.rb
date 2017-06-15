require "rails_helper"
require "webmock/rspec"

describe Api::HttpActionService do
  let(:uri){"http://www.ronglon.cu.to"}
  let(:params){{test: "test"}}
  let(:http_action){Api::HttpActionService.new(uri, params)}
  let(:json_response){{data: "Success"}}

  describe "#get_data" do
    context "get json data success" do
      before do
        stub_request(:get, uri).with(query: URI.encode_www_form(params))
          .to_return(
            status: 200,
            body: json_response.to_json,
            headers: {"Content-Type" => "application/json"}
          )
      end
      subject{http_action.get_data}

      it "return status code 200" do
        expect(subject.code).to eq "200"
      end

      it "data json response expected" do
        json_data = JSON.parse(subject.body)
        expect(json_data["data"]).to eq json_response[:data]
      end
    end

    context "get data failure" do
      it "not found 404" do
        stub_request(:get, uri).with(query: URI.encode_www_form(params))
          .to_return(
            status: 404,
            body: "",
            headers: {}
          )
        expect(http_action.get_data.code).to eq "404"
      end

      it "unprocessable entity 422" do
        stub_request(:get, uri).with(query: URI.encode_www_form(params))
          .to_return(
            status: 422,
            body: "",
            headers: {}
          )
        expect(http_action.get_data.code).to eq "422"
      end

      it "unauthorized 401" do
        stub_request(:get, uri).with(query: URI.encode_www_form(params))
          .to_return(
            status: 401,
            body: "",
            headers: {}
          )
        expect(http_action.get_data.code).to eq "401"
      end

      it "internal server 500" do
        stub_request(:get, uri).with(query: URI.encode_www_form(params))
          .to_return(
            status: 500,
            body: "",
            headers: {}
          )
        expect(http_action.get_data.code).to eq "500"
      end

      it "net/http exception" do
        stub_request(:get, uri).with(query: URI.encode_www_form(params))
          .to_timeout
        expect(http_action.get_data).to be false
      end
    end
  end

  describe "#post data" do
    context "post action success" do
      before do
        stub_request(:post, uri).with(body: URI.encode_www_form(params))
          .to_return(
            status: 200,
            body: json_response.to_json,
            headers: {"Content-Type" => "application/json"}
          )
      end
      subject{http_action.post_data}

      it "return status code 200" do
        expect(subject.code).to eq "200"
      end

      it "data json response expected" do
        json_data = JSON.parse(subject.body)
        expect(json_data["data"]).to eq json_response[:data]
      end
    end

    context "post action failure" do
      it "not found 404" do
        stub_request(:post, uri).with(body: URI.encode_www_form(params))
          .to_return(
            status: 404,
            body: "",
            headers: {}
          )
        expect(http_action.post_data.code).to eq "404"
      end

      it "unprocessable entity 422" do
        stub_request(:post, uri).with(body: URI.encode_www_form(params))
          .to_return(
            status: 422,
            body: "",
            headers: {}
          )
        expect(http_action.post_data.code).to eq "422"
      end

      it "unauthorized 401" do
        stub_request(:post, uri).with(body: URI.encode_www_form(params))
          .to_return(
            status: 401,
            body: "",
            headers: {}
          )
        expect(http_action.post_data.code).to eq "401"
      end

      it "internal server 500" do
        stub_request(:post, uri).with(body: URI.encode_www_form(params))
          .to_return(
            status: 500,
            body: "",
            headers: {}
          )
        expect(http_action.post_data.code).to eq "500"
      end

      it "net/http exception" do
        stub_request(:post, uri).with(body: URI.encode_www_form(params))
          .to_timeout
        expect(http_action.post_data).to be false
      end
    end
  end
end

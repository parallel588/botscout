require "spec_helper"

describe Botscout::Client do
  describe "#test" do
    it "should return Botscout::Client::Result" do
      VCR.use_cassette("test-spam-req") do
        @client = Botscout::Client.new
        @result = @client.test(:mail => "krasnhello@mail.ru")
        expect(@result.is_a?(Botscout::Client::Result)).to be_true
      end

    end
    context "when Botscout is not available (Errno::ETIMEDOUT)" do
      it "should return Botscout::Client::Result with error" do
        Botscout::Client.stub(:get).and_raise(Errno::ETIMEDOUT)
        @client = Botscout::Client.new
        @result = @client.test(:mail => "krasnhello@mail.ru")
        expect(@result.error).to eq("Service is not available: Connection timed out")
      end
    end
  end
  describe "Result" do

    describe "#bot?" do
      context "when data is matched" do
        it "should be true" do
          VCR.use_cassette("test-spam-req") do
            @client = Botscout::Client.new
            @result = @client.test(:mail => "krasnhello@mail.ru")
            expect(@result.bot?).to be_true
          end
        end
      end
      context "when data is not matched" do
        it "should be false" do
          VCR.use_cassette("test-not-pam-req") do
            @client = Botscout::Client.new
            @result = @client.test(:mail => "promotion@aliexpress.com")
            expect(@result.bot?).to be_false
          end
        end
      end

    end

    context "when response is has error" do
      before{
        VCR.use_cassette("test-error-req") do
          @client = Botscout::Client.new
          @result = @client.test(:mail => "promotion@aliexpress.com")

        end
      }

      it "#error should return the error message" do
        expect(@result.error).to eq(" Sorry, but that doesn't appear to be a valid API key.")
      end
      it "#has_error? should return true" do
        expect(@result.has_error?).to be_true
      end
      it "#success? should return false" do
        expect(@result.success?).to be_false
      end
    end

    context "when response is has not error" do
      before{
        VCR.use_cassette("test-spam-req") do
          @client = Botscout::Client.new
          @result = @client.test(:mail => "krasnhello@mail.ru")
        end
      }

      it "#error should return nil" do
        expect(@result.error).to be_nil
      end
      it "#has_error? should return false" do
        expect(@result.has_error?).to be_false
      end
      it "#success? should return true" do
        expect(@result.success?).to be_true
      end
    end

  end
end

require "rails_helper"

describe Esignature::Esignor do
  it "calls esignature service to send email with request for signature" do
    esignature_client = double("esignature", create_envelope_from_document: true)
    esignor = Esignature::Esignor.new(
      name: "Test Name",
      email: "valid@example.com",
      client: esignature_client
    )

    esignor.request_signature

    expect(esignature_client).to have_received(:create_envelope_from_document).
      with(any_args)
  end
end

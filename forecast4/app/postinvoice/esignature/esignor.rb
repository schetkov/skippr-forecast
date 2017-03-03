module Esignature
  class Esignor
    def initialize(name:, email:, client: DocusignRest::Client.new)
      @name = name
      @email = email
      @client = client
    end

    def request_signature
      client.create_envelope_from_document(
        email: {
          subject: "Please sign Skippr Terms and Conditions",
          body: "As a Director of the business we will require you to sign the Skippr Terms and Conditions before we can fund your invoices. Please review the documentation and execute accordingly. If you have any questions, please don't hesitate to get in touch."
        },

        signers: [
          {
            name: name,
            email: email,
            role_name: "Authorized Officer",
            sign_here_tabs: [
              {
                anchor_string: "SignHere",
                anchor_x_offset: "10",
                anchor_y_offset: "10"
              }
            ]
          }
        ],

        files: [
          path: "#{Rails.public_path}/master_services_agreement.pdf",
          name: "master_services_agreement.pdf"
        ],

        status: "sent"
      )
    end

    private

    attr_reader :name, :email, :client
  end
end

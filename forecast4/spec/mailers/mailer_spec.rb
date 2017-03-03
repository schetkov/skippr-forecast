require "rails_helper"

describe Mailer do
  context "seller emails" do
    describe ".seller_welcome_notification" do
      it "is sent to the seller" do
        seller = create(:seller)
        email = Mailer.seller_welcome_notification(seller)

        expect(email.to).to include(seller.email)
        expect(email).to have_body_text(/Hi #{seller.name.split(' ').first}/)
      end

      it "comes from the application" do
        seller = create(:seller)
        email = Mailer.seller_welcome_notification(seller)

        expect(email).to deliver_from(
          %{"Post Invoice" <no-reply@postinvoice.com.au>}
        )
      end

      it "thanks seller for signing up" do
        seller = create(:seller)
        email = Mailer.seller_welcome_notification(seller)


        expect(email.parts.last.body).to include("Thank you for signing up to PostInvoice")
      end
    end

    describe ".seller_approval_notification" do
      it "is sent to the seller" do
        seller = create(:seller)
        email = Mailer.seller_approval_notification(seller)

        expect(email.to).to include(seller.email)
        expect(email).to have_body_text(/Hi #{seller.name.split(' ').first}/)
      end

      it "comes from the application" do
        seller = create(:seller)
        email = Mailer.seller_approval_notification(seller)

        expect(email).to deliver_from(
          %{"Post Invoice" <no-reply@postinvoice.com.au>}
        )
      end

      it "informs seller of acceptance" do
        seller = create(:seller)
        email = Mailer.seller_approval_notification(seller)

        expect(email.parts.first.body).to include("You have been accepted")
      end

      it "attachs the sale and purchase agreement" do
        seller = create(:seller)
        email = Mailer.seller_approval_notification(seller)

        expect(email.parts.last.filename).to eq("sale_and_purchase_agreement.pdf")
      end
    end

    describe ".seller_payment_status_notification" do
      it "notifies the seller if payment status has been updated by admin" do
        seller = create(:seller)
        invoice = create(:invoice, seller: seller)

        email = Mailer.seller_payment_status_notification(seller, invoice)

        expect(email.parts.last.body).to include(
          "#{invoice.debtor.legal_business_name} has paid invoice"
        )
      end
    end
  end

  context "buyer emails" do
    describe ".buyer_welcome_notification" do
      it "is sent to the buyer" do
        buyer = create(:buyer)
        email = Mailer.buyer_welcome_notification(buyer)

        expect(email.to).to include(buyer.email)
        expect(email).to have_body_text(/Hi #{buyer.name.split(' ').first}/)
      end

      it "comes from the application" do
        buyer = create(:buyer)
        email = Mailer.buyer_welcome_notification(buyer)

        expect(email).to deliver_from(
          %{"Post Invoice" <no-reply@postinvoice.com.au>}
        )
      end

      it "thanks seller for signing up" do
        buyer = create(:buyer)
        email = Mailer.buyer_welcome_notification(buyer)

        expect(email.parts.last.body).to include("Thank you for signing up to PostInvoice")
      end
    end


    describe ".buyer_approval_notification" do
      it "is sent to the buyer" do
        buyer = create(:buyer)
        email = Mailer.buyer_approval_notification(buyer)

        expect(email.to).to include(buyer.email)
        expect(email).to have_body_text(/Hi #{buyer.name.split(' ').first}/)
      end

      it "comes from the application" do
        buyer = create(:buyer)
        email = Mailer.buyer_approval_notification(buyer)

        expect(email).to deliver_from(
          %{"Post Invoice" <no-reply@postinvoice.com.au>}
        )
      end

      it "informs buyer of acceptance" do
        buyer = create(:buyer)
        email = Mailer.buyer_approval_notification(buyer)

        expect(email.parts.first.body).to include("You have been accepted")
      end

      it "attachs the sale and purchase agreement" do
        buyer = create(:buyer)
        email = Mailer.buyer_approval_notification(buyer)

        expect(email.parts.last.filename).to eq("sale_and_purchase_agreement.pdf")
      end
    end

    describe ".buyer_payment_status_notification" do
      it "notifies the buyer if payment status has been updated by admin" do
        buyer = create(:buyer)
        invoice = create(:invoice)

        email = Mailer.buyer_payment_status_notification(buyer, invoice)

        expect(email.parts.last.body).to include(
          "#{invoice.debtor.legal_business_name} has paid invoice"
        )
      end
    end
  end
end

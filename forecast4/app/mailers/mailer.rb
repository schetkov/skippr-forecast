class Mailer < ActionMailer::Base
  default from: %{"Post Invoice" <no-reply@postinvoice.com.au>}

  def seller_welcome_notification(seller_account)
    @recipient = seller_account.user

    mail(
      to: seller_account.user.email,
      from: %{"Post Invoice" <no-reply@postinvoice.com.au>},
      subject: "Welcome to PostInvoice"
    )
  end

  def seller_approval_notification(seller_account)
    @recipient = seller_account.user

    file_path = "#{Rails.root}/app/assets/email_attachments/sale_and_purchase_agreement.pdf"
    attachments["sale_and_purchase_agreement.pdf"] = File.read(file_path)

    mail(
      to: seller_account.user.email,
      from: %{"Post Invoice" <no-reply@postinvoice.com.au>},
      subject: "Welcome to PostInvoice"
    )
  end

  def seller_closed_auction_notification(seller, upfront_payment)
    @recipient = seller.user
    @seller = seller
    @upfront_payment = upfront_payment

    mail(
      to: seller.email,
      from: %{"Post Invoice" <no-reply@postinvoice.com.au>},
      subject: "Congratulations! Your auction has closed"
    )
  end

  def seller_payment_status_notification(seller, invoice)
    @recipient = seller.user
    @invoice = invoice

    mail(
      to: seller.email,
      from: %{"Post Invoice" <no-reply@postinvoice.com.au>},
      subject: "Payment has been made for your invoice"
    )
  end

  ##### BUYERS EMAILS #####

  def buyer_welcome_notification(buyer)
    @recipient = buyer.user

    mail(
      to: buyer.email,
      from: %{"Post Invoice" <no-reply@postinvoice.com.au>},
      subject: "Welcome to PostInvoice"
    )
  end

  def buyer_approval_notification(buyer_account)
    @recipient = buyer_account.user


    file_path = "#{Rails.root}/app/assets/email_attachments/sale_and_purchase_agreement.pdf"
    attachments["sale_and_purchase_agreement.pdf"] = File.read(file_path)

    mail(
      to: buyer_account.user.email,
      from: %{"Post Invoice" <no-reply@postinvoice.com.au>},
      subject: "Welcome to PostInvoice"
    )
  end

  def buyer_winning_bid_notification(buyer, auction, upfront_payment)
    @recipient = buyer.user
    @auction = auction
    @seller = auction.seller
    @upfront_payment = upfront_payment

    mail(
      to: buyer.email,
      from: %{"Post Invoice" <no-reply@postinvoice.com.au>},
      subject: "Congratulations! Your bid was successful"
    )
  end

  def buyer_payment_status_notification(buyer, invoice)
    @recipient = buyer.user
    @invoice = invoice

    mail(
      to: buyer.email,
      from: %{"Post Invoice" <no-reply@postinvoice.com.au>},
      subject: "Payment has been made for your invoice"
    )
  end
end

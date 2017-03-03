class MailerPreview < ActionMailer::Preview

  def seller_welcome_notification
    Mailer.seller_welcome_notification(Seller.first)
  end

  def seller_approval_notification
    Mailer.seller_approval_notification(Seller.first)
  end

  def buyer_welcome_notification
    Mailer.buyer_welcome_notification(Buyer.first)
  end

  def buyer_approval_notification
    Mailer.buyer_approval_notification(Buyer.first)
  end

  def buyer_winning_bid_notification
    buyer = Buyer.first
    seller = Seller.first
    invoice = Invoice.closed_auction_invoices.last
    Mailer.buyer_winning_bid_notification(buyer, seller, invoice, 100000)
  end

  def seller_auction_closed_notification
    seller = Seller.first
    invoice = Invoice.closed_auction_invoices.last
    Mailer.seller_auction_closed_notification(seller, invoice, 100000)
  end

  def seller_payment_status_notification
    seller = Seller.first
    invoice = Invoice.closed_auction_invoices.last
    Mailer.seller_payment_status_notification(seller, invoice)
  end
end

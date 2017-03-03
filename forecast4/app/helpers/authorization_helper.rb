module AuthorizationHelper

  def buyer_or_auction_belongs_to_seller(auction)
    current_buyer || (current_seller == auction.seller)
  end
end

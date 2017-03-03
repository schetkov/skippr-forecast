class XeroDataRetrieverJob < ActiveJob::Base
  queue_as :high_priority

  def perform(args)
    xero_record = XeroAuthorisation.find(args.fetch(:xero_id))
    seller = Seller.find(args.fetch(:seller_id))

    XeroApi::DataRetriever.new(xero_record, seller).call
  end
end

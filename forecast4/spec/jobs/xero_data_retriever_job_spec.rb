require 'rails_helper'

describe XeroDataRetrieverJob do
  it "retrieves data from xero" do
    seller = create(:seller)
    xero_record = create(:xero_authorisation)
    data_retriever = double("data_retriever", call: true)
    allow(XeroApi::DataRetriever).to receive(:new).
      with(xero_record, seller).and_return(data_retriever)

    XeroDataRetrieverJob.perform_now(xero_id: xero_record.id, seller_id: seller.id)

    expect(XeroApi::DataRetriever).to have_received(:new).
      with(xero_record, seller)
    expect(data_retriever).to have_received(:call)
  end
end

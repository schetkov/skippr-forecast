module SellerHelper
  def seller_company_status(seller_company)
    if seller_company && seller_company.approved?
      "Approved"
    else
      "Awaiting Approval"
    end
  end

  def link_to_admin_seller_path(seller)
    if seller.seller_company
      link_to admin_seller_company_path(seller.seller_company) do
        seller.seller_company_name
      end
    else
      'N/A'
    end
  end
end

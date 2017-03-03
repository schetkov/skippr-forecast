module Invoices
  class RatingApplier
    def initialize(invoice, rating_value)
      @invoice = invoice
      @rating_value = rating_value
      @master_rating = MasterRating.find_by(rating_value: rating_value)
    end

    def call
      if rating_value
        invoice.update(rating_value: rating_value)
        create_or_update_invoice_rating
      end
    end

    private

    attr_reader :invoice, :rating_value, :master_rating

    def create_or_update_invoice_rating
      if invoice.rating.nil?
        invoice.create_rating(rating_attributes)
      else
        invoice.rating.update(rating_attributes)
      end
    end

    def rating_attributes
      {
        master_rating_value: master_rating.rating_value,
        discount_rate: master_rating.discount_rate,
        advance_amount: master_rating.advance_amount,
        master_rating_applied_at: Time.current
      }
    end
  end
end

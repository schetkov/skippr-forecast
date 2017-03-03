module Radar
  class InvoiceSerializer < ActiveModel::Serializer
    root false
    attributes :id, :due_date, :anticipated_pay_date,
               :face_value, :xero_type, :debtor_id,
               :debtor, :date_data, :amount_due

    def date_data
      {
        due_date: {
          year: object.due_date.year,
          month: object.due_date.month,
          day: object.due_date.day
        },
        anticipated_pay_date: {
          year: object.anticipated_pay_date.year,
          month: object.anticipated_pay_date.month,
          day: object.anticipated_pay_date.day
        }
      }
    end

    def face_value
      format "%.2f", object.face_value
    end

    def amount_due
      format "%.2f", object.amount_due
    end

    def debtor
      object.debtor.legal_business_name
    end
  end
end

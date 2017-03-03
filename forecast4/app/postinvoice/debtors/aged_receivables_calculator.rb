module Debtors
  class AgedReceivablesCalculator

    THIRTY_DAYS = 30
    SIXTY_DAYS = 60
    NINETY_DAYS = 90

    def initialize(xero_client, debtor)
      @xero_client = xero_client
      @debtor = debtor
    end

    def call
      debtor.update(
        thirty_days: aged_receivables_summary[:thirty_days],
        sixty_days: aged_receivables_summary[:sixty_days],
        ninety_days: aged_receivables_summary[:ninety_days],
        over_ninety_days: aged_receivables_summary[:over_ninety_days],
        aged_receivables_last_updated_at: DateTime.now
      )
    end

    private

    attr_reader :xero_client, :debtor

    def receivables
      @receivables ||= receivable_values_minus_summary_row
    end

    def receivable_values_minus_summary_row
      receivable_values.take(receivable_values.size - 1)
    end

    def receivable_values
      section_row.rows.inject([]) do |result, row|
        result << [row.cells.first.value, row.cells.last.value]
      end
    end

    def not_a_summary_row?(row)
      !row.cells.first.value.is_a? String
    end

    def section_row
      report.rows.last
    end

    def report
      xero_client.AgedReceivablesByContact.get(contactId: debtor.contact_id)
    end

    def aged_receivables_summary
      {
        thirty_days: receivable_values_for_payment_period(:thirty),
        sixty_days: receivable_values_for_payment_period(:sixty),
        ninety_days: receivable_values_for_payment_period(:ninety),
        over_ninety_days: receivable_values_for_payment_period(:over_ninety)
      }
    end

    def receivable_values_for_payment_period(period)
      receivables_for(period).inject(0) do |result, receivable|
        result += receivable[1]
      end
    end

    def receivables_for(period)
      receivables.select do |receivable|
        days = (Time.now - receivable[0]) / 1.day
        receivable_payment_period_within_period?(days, period)
      end
    end

    def receivable_payment_period_within_period?(days, period)
      case period
      when :thirty
        less_than_or_equal_to_thirty_days(days)
      when :sixty
        greater_than_thirty_days_less_than_or_equal_to_sixty_days(days)
      when :ninety
        greater_than_sixty_days_less_than_or_equal_to_ninety_days(days)
      when :over_ninety
        greater_than_ninety_days(days)
      end
    end

    def less_than_or_equal_to_thirty_days(days)
      days <= THIRTY_DAYS
    end

    def greater_than_thirty_days_less_than_or_equal_to_sixty_days(days)
      days > THIRTY_DAYS && days <= SIXTY_DAYS
    end

    def greater_than_sixty_days_less_than_or_equal_to_ninety_days(days)
      days > SIXTY_DAYS && days <= NINETY_DAYS
    end

    def greater_than_ninety_days(days)
      days > NINETY_DAYS
    end
  end
end

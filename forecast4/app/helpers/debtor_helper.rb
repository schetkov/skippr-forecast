module DebtorHelper
  def sum_of_oustanding_aged_receivables(debtor)
    debtor.thirty_days +
      debtor.sixty_days +
      debtor.ninety_days +
      debtor.over_ninety_days
  end

  def last_updated_date_for_aged_receivables(debtor)
    if debtor.aged_receivables_last_updated_at
      "(Last updated at:" +
        " #{debtor.aged_receivables_last_updated_at.strftime("%-d %B %Y")})"
    else
      ""
    end
  end
end

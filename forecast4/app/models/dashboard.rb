class Dashboard < SimpleDelegator

  def confirmed_trades
    trades.confirmed
  end

  def approved_invoices
    invoices.available_for_trade
  end

  def pending_invoices
    invoices.
      with_pending_state.
      where("due_date > ?", Time.zone.now).
      order(updated_at: :desc)
  end

  def awaiting_approval_invoices
    invoices.
      with_selected_state.
      order(updated_at: :desc)
  end

  private

  attr_reader :seller
end

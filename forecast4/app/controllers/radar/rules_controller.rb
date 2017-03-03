class Radar::RulesController < ApplicationController
  before_action :set_scenario
  before_action :set_rule, only: [:update, :destroy, :show]

  def index
    @rules = if params[:receivables]
      @scenario.rules.receivables.order(:created_at).order(:id)
    elsif params[:payables]
      @scenario.rules.payables.order(:created_at).order(:id)
    end
    render json: @rules
  end

  def create
    original = @scenario.rules.create!(rule_params)
    original.update_attributes!(initial_date: DateTime.parse(rule_params[:initial_date]).to_date)
    if !rule_params[:due_date].nil?
      original.update_attributes!(terms: (original.due_date - original.initial_date).to_i)
    else
      original.update_attributes!(due_date: original.initial_date + original.terms.days) if rule_params[:due_date].nil?
    end
    create_clones(original)
    render json: @scenario.rules.where("id = ? OR parent_id = ?", original.id, original.id).order(is_clone: :desc).each {|item| item.reload }
  end

  def update
    @rule.update!(rule_params)
    if !rule_params[:due_date].present?
      @rule.update_attributes!(due_date: @rule.initial_date + @rule.terms.days)
    end
    @rule.update_attributes!(terms: (@rule.due_date - @rule.initial_date).to_i)
    destroy_or_create_clones(@rule) if params[:is_hidden].present?
    update_clones(@rule)
    render json: @scenario.rules.where("id = ? OR parent_id = ?", @rule.id, @rule.id).order(is_clone: :desc)
  end

  def destroy
    render json: @rule if @rule.destroy!
    CashFlowRule.where(parent_id: @rule.id).each do |clone|
      clone.destroy!
    end
  end

protected

  def set_scenario
    @scenario = current_seller.scenarios.find(params[:scenario_id])
  end

  def set_rule
    @rule = @scenario.rules.find(params[:id])
  end

  def rule_params
    if params[:cash_flow_rule][:rule_type] == 'sales'
      sales_rule_params
    else
      expence_rule_params
    end
  end
  
  def create_clones(rule)
    if rule.rule_type != 'other_expenses' || rule.reccuring == true
      for i in 1..3 do
        clone = @scenario.rules.new(rule_params)
        clone.is_clone = true
        clone.initial_date = rule.initial_date + (rule.interval*i).days
        clone.due_date = clone.initial_date + rule.terms.days
        clone.parent_id = rule.id
        clone.save!
      end
    else if rule.rule_type == 'other_expenses' && rule.reccuring == true
      for i in 1..3 do
        clone = @scenario.rules.new(rule_params)
        clone.is_clone = true
        clone.initial_date = rule.initial_date + (rule.interval*i).days
        clone.due_date = clone.initial_date + rule.terms.days
        clone.parent_id = rule.id
        clone.terms = rule.terms
        clone.save!
      end
    end
  end
end
  
  def destroy_or_create_clones(rule)
    if rule.rule_type == 'other_expenses'
    CashFlowRule.where(parent_id: rule.id).each do |clone|
      clone.destroy!
    end
    elsif rule.reccuring
      create_clones(rule) if CashFlowRule.where(parent_id: rule.id).count != 3
    end
  end

  def update_clones(rule)
    rule_clones = @scenario.rules.where(parent_id: rule.id).order('id ASC')
    rule_clones.each_with_index do |clone, i|
      clone.update_attributes(
      amount: rule.amount,
      debtor_id: rule.debtor_id,
      interval: rule.interval,
      terms: rule.terms,
      initial_date: rule.initial_date + (rule.interval*(i+1)).days,
      due_date: rule.initial_date + (rule.interval*(i+1)).days + rule.terms.days,
      other_expenses_name: rule.other_expenses_name
        )
    end
  end
  
  def sales_rule_params
    params.require(:cash_flow_rule).permit(:amount, :interval, :terms, :rule_type, :debtor_id, :due_date, :is_clone, :is_hidden, :is_sold,  :parent_id, :initial_date).merge(seller_id: current_seller.id)
  end

  def expence_rule_params
    params.require(:cash_flow_rule).permit(:amount, :interval, :terms, :rule_type, :vendor_id, :due_date, :is_clone, :is_hidden, :is_sold, :parent_id, :initial_date, :other_expenses_name, :reccuring).merge(seller_id: current_seller.id)
  end

end

module RegistrationFormHelper
  def sophisticated_investor
    params['investor_type'] == 'sophisticated' ||
      params['registration_sophisticated_investor'].present?
  end

  def high_net_worth_individual
    params['investor_type'] == 'high_net_worth' ||
      params['registration_high_net_worth_individual'].present?
  end

  def institution
    params['investor_type'] == 'institution' ||
      params['registration_institution'].present?
  end
end

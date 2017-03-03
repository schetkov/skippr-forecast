class PagesController < ApplicationController
  include HighVoltage::StaticPage

  layout :layout_for_page

  skip_before_action :require_login

  private

  def layout_for_page
    case params[:id]
    when 'home'
      'home'
    when 'company'
      'home'
    when 'businesses'
      'home'
    when 'faq'
      'home'
    when 'investors'
      'home'
    when 'privacy'
      'home'
    when 'terms'
      'home'
    when 'landing_page'
      'landing'
    when 'print_terms'
      'print'
    else
      'application'
    end
  end
end

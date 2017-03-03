require 'rails_helper'

feature 'Visitor sees homepage' do
  scenario 'with welcome text' do
    visit signed_out_root_path

    expect(page).to have_content "Sign in"
  end
end

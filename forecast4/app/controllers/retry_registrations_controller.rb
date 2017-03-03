class RetryRegistrationsController < ApplicationController
  def update
    current_seller.update(workflow_state: "msa_reviewed")
    redirect_to new_xero_path
  end
end

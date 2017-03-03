class Admin::NoticeOfAssignmentsController < ApplicationController
  def destroy
    invoice = Invoice.find(params[:invoice_id])
    notice_of_assignment = invoice.attachments.where(id: params[:id])
    notice_of_assignment.destroy
    redirect_to admin_invoice_path(invoice)
  end
end

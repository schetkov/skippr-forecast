class BuyerCompaniesController < ApplicationController

  layout 'company'

  def update
    @company = current_buyer.buyer_company
    update_avatar
    if @company.update(company_params)
      flash[:success] = 'Your company information has been updated'
    else
      flash[:danger] = 'Sorry there was an error updating your company information'
    end
    redirect_to :back
  end

  private

  def company_params
    params.require(:buyer_company).permit(
      :name,
      :phone_number,
      :website,
      :acn,
      :description,
    )
  end

  def update_avatar
    if params[:buyer_company][:avatar]
      @company.update(avatar_id: avatar_file_id)
    end
  end

  def avatar_file_id
    cloudinary_file_attribute.first[:file_id]
  end

  def cloudinary_file_attribute
    Attachments::CloudinaryAttributeBuilder.new(params[:buyer_company]).call
  end
end

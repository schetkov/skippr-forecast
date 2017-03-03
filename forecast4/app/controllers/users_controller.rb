class UsersController < Clearance::UsersController

  skip_before_action :require_login, only: [:new, :create]

  layout "account", only: [:edit]
  layout "session", only: [:new, :create, :signed_up]

  def new
    @signup = Registration::UserSignup.new
  end

  def create
    @signup = Registration::UserSignup.new(sign_up_params).call
    if @signup.user.persisted?
      sign_in @signup.user
      redirect_back_or url_after_create
    else
      render "new"
    end
  end

  def edit
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:success] = "Your account settings have been updated"
    else
      flash[:danger] = "Sorry there was an error updating your settings"
    end
    redirect_to :back
  end

  def signed_up
  end

  private

  def url_after_create
    analytics.track_user_creation
    sign_out
    signed_up_path
  end

  def sign_up_params
    params.require(:registration_user_signup).permit(
      :name,
      :email,
      :company_name,
      :acn,
      :website,
      :phone_number,
      :password
    )
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password
    )
  end
end

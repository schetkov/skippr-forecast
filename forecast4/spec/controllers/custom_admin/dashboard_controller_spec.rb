require "rails_helper"

describe CustomAdmin::DashboardController do
  describe "GET on #index" do
    context "logged in admin user" do
      it "shows dashboard page" do
        user = create(:user,
                      :admin,
                      email: 'admin@example.com',
                      password: 'Foobar1234')
        sign_in(user)

        get :index

        expect(response).to render_template :index
      end
    end

    context "admin user not logged in" do
      it "redirects to sign in page" do
        create(:user,
               :admin,
               email: 'admin@example.com',
               password: 'Foobar1234')

        get :index

        expect(response).to redirect_to sign_in_path
      end
    end

    context "non-admin user" do
      it "redirects user to sign in page" do
        user = create(:user,
                      email: 'admin@example.com',
                      password: 'Foobar1234')
        sign_in(user)

        get :index

        expect(response).to redirect_to sign_in_path
      end
    end
  end
end

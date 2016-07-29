class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def stripe_connect
    @user = current_user
    auth_info = request.env['omniauth.auth']
    if @user.update_attributes({
                                 stripe_user_id: auth_info.uid,
                                 stripe_access_code: auth_info.credentials.token,
                                 stripe_pub_key: auth_info.info.stripe_publishable_key
                               })
      set_flash_message(:notice, :success, :kind => "Stripe") if is_navigational_format?
      redirect_to '/#/dashboard/account/information'
    else
      session["devise.stripe_connect_data"] = auth_info
      redirect_to :back
    end
  end
end
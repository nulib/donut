class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # The default OmniAuth forms don't provide CSRF tokens, so we can't verify
  # them. Trying to verify results in a cleared session.
  skip_before_action :verify_authenticity_token

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def openam
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      flash[:success] = I18n.t('devise.omniauth_callbacks.success')
      sign_in @user, event: :authentication
      user_session[:full_login] = true
    end

    if request['target_id']
      redirect_to object_path(request['target_id'])
    elsif params[:url]
      redirect_to params[:url]
    elsif session[:previous_url]
      redirect_to session.delete :previous_url
    else
      redirect_to root_url
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def failure
    flash[:error] = I18n.t('devise.omniauth_callbacks.failure')
    redirect_to root_path
  end
end

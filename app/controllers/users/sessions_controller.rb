class Users::SessionsController < Devise::SessionsController
  def new
    redirect_to user_omniauth_authorize_path(:nusso)
  end

  def destroy
    super
    flash[:success] = flash[:notice]
    flash[:notice] = nil
  end
end

class SessionsController < ApplicationController
  def new; end

  def check_user_authenticate user
    user && user.authenticate(params[:session][:password])
  end

  def check_user_validate user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    if current_user.admin?
      redirect_to admin_path
    else
      redirect_back_or user
    end
  end

  def check_user_activate user
    if user.activated?
      check_user_validate user
    else
      message  = t "controller.sessions.not_activated"
      message += t "controller.sessions.check"
      flash[:warning] = message
      redirect_to root_url
    end
  end

  def create
    if params[:session].present?
      user = User.find_by email: params[:session][:email].downcase
      if check_user_authenticate user
        check_user_activate user
      else
        flash.now[:danger] = t "controller.sessions.danger"
        render :new
      end
    else
      begin
        user = User.from_omniauth(request.env['omniauth.auth'])
        session[:user_id] = user.id
        flash[:success] = "Welcome, #{user.email}!"
      rescue
        flash[:warning] = "Error!!!"
      end
      redirect_to root_url
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end

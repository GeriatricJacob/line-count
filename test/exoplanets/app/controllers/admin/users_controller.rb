class Admin::UsersController < Admin::ApplicationController
  load_and_authorize_resource

  def create
    @user = User.new user_params

    if @user.save
      redirect_to edit_admin_user_path(@user), notice: 'User created'
    else
      render :new, status: 422
    end
  end

  def update
    @user.update_attributes user_params
    if @user.save
      redirect_to admin_users_path, notice: "User updated."
    else
      render :edit, status: 422, alert: "Unable to update user."
    end
  end

  def user_params
    params.require(:user)
    .permit(:first_name, :email, :password, :password_confirmation, :last_name, :avatar)
  end
end

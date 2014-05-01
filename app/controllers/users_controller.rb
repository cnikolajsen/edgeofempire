class UsersController < ApplicationController
  before_filter :set_up

  def set_up
    @page = 'users'
    @title = "User"
  end

  private

  def user_params
     params.require(:user).permit( :email, :password, :password_confirmation, :remember_me )
  end
end

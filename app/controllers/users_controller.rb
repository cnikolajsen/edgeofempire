class UsersController < ApplicationController
  #before_filter :authenticate_user!

  #def index
  #  @users = User.all
  #
  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.json { render json: @users }
  #  end
  #end
  #  
  #def new
  #  @user = User.new
  #end
  #
  #def create
  #  @user = User.new(params[:user])
  #  if @user.save
  #    session[:user_id] = @user.id
  #    flash[:notice] = "Thank you for signing up! You are now logged in."
  #    redirect_to "/"
  #  else
  #    render :action => 'new'
  #  end
  #end
end

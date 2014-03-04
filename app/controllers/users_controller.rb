class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
  end
  
  def generate
    @user = current_user
    private = RbNaCl::PrivateKey.generate
    public = private.public_key
    @user.priv_key = private.to_bytes
    @user.public_key = public.to_bytes
    @user.save
    redirect_to users_path
  end
end

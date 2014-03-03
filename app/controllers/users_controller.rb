class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  private
  def generate
    @user = current_user
    @user.priv_key = RbNaCl::PrivateKey.generate
    @user.public_key = @user.privkey.public_key
    @user.save
  end
end

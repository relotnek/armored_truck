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
    @user.public_key = public.to_bytes
    @user.save
    send_data private, :filename => "ac_privkey"
  end
end

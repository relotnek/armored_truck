class KeysController < ApplicationController
  def index
    @user = current_user
    @key = @user.keys.new()
    @keys = Key.where("user_id = ?", @user.id)
  end

  def new
    @user = current_user
    @key = @user.keys.new()
  end

  def create
    @user = current_user
    @keys = Key.where("user_id = ?", @user.id)
    @key = @user.keys.create(key_params)
    private = RbNaCl::PrivateKey.generate
    public = private.public_key
    @key.public_key = public.to_bytes
    @key.save
    respond_to do |format|
      format.html { send_data private, :filename => "ac_privkey" }
      format.js
    end
  end

  def show
    @key = Key.find(params[:id])
  end

  def edit
  end

  def key_params
    params.require(:key).permit(:name)
  end

end

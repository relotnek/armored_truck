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
    respond_to do |format|
      format.js
    end
  end

  def generate
    @user = current_user
    @key = @user.keys.find(params[:key])
    private = RbNaCl::PrivateKey.generate
    public = private.public_key
    @key.public_key = public.to_bytes
    @key.save
    send_data private, :filename => "ac_privkey"
  end

  def show
    @key = Key.find(params[:id])
  end

  def edit
  end

  def key_params
    params.require(:key).permit(:name, :id)
  end

end
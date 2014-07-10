class KeysController < ApplicationController
  def index
    #specifies the current_user to display keys
    @user = current_user
    #creates a blank key so the form works in the view
    @key = @user.keys.new()
    #creates a list of keys for display to the user
    @keys = Key.where("user_id = ?", @user.id)
  end

  def create
    #specifies the current user for key creation
    @user = current_user
    #specifies all keys associated with a user so that they can be
    #displayed using ajax to the users key table
    @keys = Key.where("user_id = ?", @user.id)
    #creates a new key using the name provided in the form
    @key = @user.keys.create(key_params)
    #responds to ajax request
    respond_to do |format|
      format.html { redirect_to keys_path }
      format.js
    end
  end

  def show
    @key = Key.find(params[:id])
  end

  def generate
    #specifies curent user so it can be used by @key
    @user = current_user
    #finds the key name to generate a keypair for
    @key = @user.keys.find(params[:key])
    #creates a private key
    private = RbNaCl::PrivateKey.generate
    #creates a public key for the private key
    public = private.public_key
    #writes the public key to the database
    @key.public_key = public.to_bytes
    #saves the key
    @key.save
    #sends private key to the user as a download so that it is never stored server side
    send_data private, :filename => "#{@key.name}"
  end

  def show
    # finds the key to show
    @key = Key.find(params[:id])
  end

  #defines accepted parameters
  def key_params
    params.require(:key).permit(:name, :id)
  end

end

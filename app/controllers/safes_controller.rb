class SafesController < ApplicationController
before_filter :authenticate_user!

def index
  #specifies current user so that only that users safes are shown
  @user = current_user
  @safes = Safe.where("user_id = ?", @user.id)
end

def new
  #prepares a new safe under the current_user
  @user = current_user
  @safe = @user.safes.new()
end

def create
  #creates a new safe under the current user
  @user = current_user
  @safe = @user.safes.create(safe_params)
  redirect_to safes_path
end

def show
  #shows a safe by the id. Logic in the view will prevent unauthorized safe views
  @safe = Safe.find(params[:id])
end

def update
  @safe = Safe.find(params[:id])
  redirect_to safes_path
end

def upload
  @user = current_user
  @recipient = User.find_by(email: params[:recipient_id])
  @key = @recipient.keys.where("name = ?", params[:key_name])
  uploaded_io = params[:safe][:rawfile]
  priv_key = params[:safe][:priv_key]

    box = RbNaCl::Box.new(@key.first.public_key, priv_key.read)
    nonce = RbNaCl::Random.random_bytes(box.nonce_bytes)
    message = uploaded_io.read
    ciphertext = box.encrypt(nonce,message)
    full = nonce + ciphertext

    send_data full, :filename => uploaded_io.original_filename
end

def decrypt
  @user = current_user
  @sender = User.find_by(email: params[:sender_id])
  @key = @sender.keys.where("name = ?", params[:key_name])
  uploaded_io = params[:safe][:rawfile]
  nonce_io = params[:safe][:noncefile]
  priv_key = params[:safe][:priv_key]
    box = RbNaCl::Box.new(@key.first.public_key, priv_key.read)
    ciphertext = uploaded_io.read
    message = box.decrypt(ciphertext.slice(0,24),ciphertext.slice(24,ciphertext.length))

  send_data message, :filename => uploaded_io.original_filename
end

private
def safe_params
  params.require(:safe).permit(:name, :description, :rawfile, :noncefile)
end

end

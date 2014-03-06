class SafesController < ApplicationController
before_filter :authenticate_user!

def index
  @user = current_user
  @safes = Safe.where("user_id = ?", @user.id)
end

def new
  @user = current_user
  @safe = @user.safes.new()
end

def create
  @user = current_user
  @safe = @user.safes.create(safe_params)
  redirect_to safes_path
end

def show
  @safe = Safe.find(params[:id])
end

def edit
end

def update
  @safe = Safe.find(params[:id])
  redirect_to safes_path
end

def upload
  @user = current_user
  @recipient = User.find_by(email: params[:recipient_id])
  uploaded_io = params[:safe][:rawfile]
  priv_key = params[:safe][:priv_key]
  File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|

    box = RbNaCl::Box.new(@recipient.public_key, priv_key.read)
    @nonce = RbNaCl::Random.random_bytes(box.nonce_bytes)
    message = uploaded_io.read
    ciphertext = box.encrypt(@nonce,message)
    File.open(Rails.root.join('public','uploads', "vt-#{uploaded_io.original_filename}"), 'wb') do |noncefile|
    noncefile.write(@nonce)
    end
    
    file.write(ciphertext)
  end

  redirect_to safes_path
end

def decrypt
  @user = current_user
  @sender = User.find_by(email: params[:sender_id])
  uploaded_io = params[:safe][:rawfile]
  nonce_io = params[:safe][:noncefile]
  priv_key = params[:safe][:priv_key]
    box = RbNaCl::Box.new(@sender.public_key, priv_key.read)
    @nonce = nonce_io.read
    ciphertext = uploaded_io.read
    message = box.decrypt(@nonce,ciphertext)
    
  send_data message, :filename => uploaded_io.original_filename 
end

private
def safe_params
  params.require(:safe).permit(:name, :description, :rawfile, :noncefile)
end

end
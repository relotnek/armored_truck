class SafesController < ApplicationController
before_filter :authenticate_user!

def index
  @safes = Safe.all
end

def new
  @safe = Safe.new()
end

def create
  @safe = Safe.create(safe_params)
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
  uploaded_io = params[:safe][:rawfile]
  File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|

    box = RbNaCl::Box.new(@user.priv_key, @user.public_key)
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

private
def safe_params
  params.require(:safe).permit(:id, :name, :description,:rawfile)
end

end

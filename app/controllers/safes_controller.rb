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

    box = RbNaCl::Box.new(@recipient.public_key, priv_key.read)
    nonce = RbNaCl::Random.random_bytes(box.nonce_bytes)
    message = uploaded_io.read
    ciphertext = box.encrypt(nonce,message)
    
  send_data nonce, :filename => "vt-#{uploaded_io.original_filename}"
  send_data ciphertext, :filename => "encrypted-#{uploaded_io.original_filename}"
  
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
    nonce = nonce_io.read
    ciphertext = uploaded_io.read
    message = box.decrypt(nonce,ciphertext)
    
  send_data message, :filename => uploaded_io.original_filename 
end

def download_zip(file_list)
    if !file_list.blank?
      file_name = "encrypted.zip"
      t = Tempfile.new("my-temp-filename-#{Time.now}")
      Zip::ZipOutputStream.open(t.path) do |z|
        file_list.each do |raw|
          title = raw.title
          z.put_next_entry(title)
          z.print IO.read(raw.path)
          raw.close
        end
      end
      send_data t, :type => 'application/zip',
                             :disposition => 'attachment',
                             :filename => file_name
      t.close
    end
  end

private
def safe_params
  params.require(:safe).permit(:name, :description, :rawfile, :noncefile)
end

end
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
    
  x = File.open(Rails.root.join('public','uploads', "encrypted-#{uploaded_io.original_filename}"), 'wb') do |cipherfile|
  cipherfile.write(ciphertext)
  end
  
  y = File.open(Rails.root.join('public','uploads', "vt-#{uploaded_io.original_filename}"), 'wb') do |noncefile|
  noncefile.write(nonce)
  end
  
  download_zip(y,x)
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

def download_zip(nonce, ciphertext)
  #Attachment name
  filename = 'encrypted.zip'
  temp_file = Tempfile.new(filename)
 
  begin
    #This is the tricky part
    #Initialize the temp file as a zip file
    Zip::OutputStream.open(temp_file) { |zos| }
 
    #Add files to the zip file as usual
    Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
      nonce
      ciphertext
    end
 
    #Read the binary data from the file
    zip_data = File.read(temp_file.path)
 
    #Send the data to the browser as an attachment
    #We do not send the file directly because it will
    #get deleted before rails actually starts sending it
    send_data(zip_data, :type => 'application/zip', :filename => filename)
  ensure
    #Close and delete the temp file
    temp_file.close
    temp_file.unlink
  end
end

private
def safe_params
  params.require(:safe).permit(:name, :description, :rawfile, :noncefile)
end

end
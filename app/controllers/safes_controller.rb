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
end

def show
  @safe = Safe.find(params[:id])
end

def edit
end

def upload
  uploaded_io = params[:safe][:rawfile]
  File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    file.write(uploaded_io.read)
  end
end

private
def safe_params
  params.require(:safe).permit(:id, :name, :description,:rawfile)
end

end

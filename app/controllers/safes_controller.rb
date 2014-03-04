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
  @safe = Safe.find(safe_params)
end

def edit
end

private
def safe_params
  params.require(:safe).permit(:name, :description)
end

end

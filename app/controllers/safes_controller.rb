class SafesController < ApplicationController
before_filter :authenticate_user!

def index
  @safes = Safe.all
end

def new
  @safe = Safe.new()
end

def create
end

def show
  @safe = Safe.find(params[:id])
end

def edit
end

end

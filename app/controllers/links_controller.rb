class LinksController < ApplicationController
  def index
    @links = Link.all
  end

  def show
    puts params[:id]
    @link = Link.find(params[:id])
    puts @link.to_s
  end

  def new

  end

  def create
    @link = Link.new(link_params)
    @link.save
    redirect_to @link
  end

  private

  def link_params
    params.require(:link).permit(:url, :shortlink, :argsstr)
  end
end

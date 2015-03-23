class LinksController < ApplicationController
  before_action :load_link, only: [:show, :edit, :update, :destroy]

  def index
    @links = Link.search(params[:query])
  end

  def show
  end

  def new
    if params.member? :link
      @link = Link.new(link_params)
    end
  end

  def edit
  end

  def update
    if @link.update(link_params)
      redirect_to @link
    else
      render 'edit'
    end
  end

  def create
    @link = Link.new(link_params)
    if @link.save
      redirect_to @link
    else
      render 'new'
    end
  end

  def destroy
    @link.destroy
    redirect_to action: :index
  end

  private

  def load_link
    @link = Link.find params[:id]
  end

  def link_params
    params.require(:link).permit(:url, :shortlink, :argsstr, :description)
  end
end

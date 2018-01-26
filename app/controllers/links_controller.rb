class LinksController < ApplicationController
  before_action :load_link, only: [:show, :edit, :update, :destroy]

  def index
    @links = Link.search(params[:query])
    respond_to do |format|
      format.html {}
      format.json {}
    end
  end

  def show
  end

  def new
    return unless params.member? :link

    @relevant_links = Link
      .levenshtein_distances(link_params[:shortlink])
      .sort_by(&:distance)
      .reject { |link| link.distance > 5}
      .first(5)
      .map(&:link)

    @link = Link.new(link_params)
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
    params.require(:link).permit(:url, :shortlink, :argsstr, :description, :type)
  end
end

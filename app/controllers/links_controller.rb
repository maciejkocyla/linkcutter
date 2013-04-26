class LinksController < ApplicationController
  require "net/http"

  helper_method :sort_column, :sort_direction

  def index
    @links = Link.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @link = Link.find(params[:id])
  end

  def new
    @link = Link.new
  end

  def create
    @link = Link.new(params[:link])
        
    if @link.save
      redirect_to @link, :notice => "Successfully created link."
    else
      render :action => 'new'
    end
  end

  def edit
    @link = Link.find(params[:id])
  end

  def update
    @link = Link.find(params[:id])
    if @link.update_attributes(params[:link])
      redirect_to @link, :notice  => "Successfully updated link."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @link = Link.find(params[:id])
    @link.destroy
    redirect_to links_url, :notice => "Successfully destroyed link."
  end

  def recent
    @links = Link.all
  end

  def redirect
    @link = Link.find_by_short_url(params[:short_url])
    redirect_to @link.full_url

  end

  private
  
  def sort_column
    Link.column_names.include?(params[:sort]) ? params[:sort] : "short_url"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end

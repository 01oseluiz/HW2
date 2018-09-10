# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  before_action :check_session, only: [:index]

  def check_session
    if params[:sort_by].nil? && params[:ratings].nil?
      session[:sort_by] = params[:sort_by]
      session[:ratings] = params[:ratings]
    elsif params[:sort_by].nil? && !params[:ratings].nil?
      session[:ratings] = params[:ratings]
    elsif !params[:sort_by].nil? && params[:ratings].nil?
      session[:sort_by] = params[:sort_by]
    end
  end

  def index
    sort = session[:sort_by] unless session[:sort_by].nil?
    sort = Movie.has_attribute?(sort) ? sort : ""

    @check_box = session[:ratings].nil? ? Movie.all_ratings : session[:ratings].each_key.to_a

    @all_ratings = Movie.all_ratings

    @movies = Movie.order(sort).where(rating: @check_box)

  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def new
    @movie = Movie.new
  end

  def create
    #@movie = Movie.create!(params[:movie]) #did not work on rails 5.
    @movie = Movie.create(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created!"
    redirect_to movies_path
  end

  def movie_params
    params.require(:movie).permit(:title,:rating,:description,:release_date)
  end

  def edit
    id = params[:id]
    @movie = Movie.find(id)
    #@movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    #@movie.update_attributes!(params[:movie])#did not work on rails 5.
    @movie.update(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated!"
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was deleted!"
    redirect_to movies_path
  end
end
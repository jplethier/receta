class RecipesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    if params[:keywords]
      @recipes = Recipe.by_name(params[:keywords])
    else
      @recipes = []
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def create
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
      render :show, status: 201
    else
      render :new, status: 422
    end
  end

  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update_attributes(recipe_params)
      head :no_content
    else
      render :edit, status: 422
    end
  end

  def destroy
    recipe = Recipe.find(params[:id])
    recipe.destroy
    head :no_content
  end

  protected

  def recipe_params
    params.require(:recipe).permit(:name, :instructions)
  end
end

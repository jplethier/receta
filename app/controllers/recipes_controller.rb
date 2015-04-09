class RecipesController < ApplicationController
  def index
    if params[:keywords]
      @recipes = Recipe.by_name(params[:keywords])
    else
      @recipes = []
    end
  end
end

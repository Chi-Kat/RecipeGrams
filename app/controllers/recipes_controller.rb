require "net/https"
require "uri"

class RecipesController < ApplicationController
  # GET /recipes
  # GET /recipes.json

  def home

    @q = params["q"]

    if @q.present?
      puppy = URI.parse("http://www.recipepuppy.com/api/?q=#{@q}")
      http = Net::HTTP.new(puppy.host, puppy.port)
      ask = Net::HTTP::Get.new(puppy.request_uri)
      answer = http.request(ask)
      @info = JSON.parse(answer.body)


      token = '' 

      uri = URI.parse("https://api.instagram.com/v1/tags/#{@q}/media/recent?access_token=#{token}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      @information = response.body
      @hash = JSON.parse(@information)
    end

  end

  def index
    @recipes = Recipe.all


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @recipes }
    end
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show

    @recipe = Recipe.find(params[:id])

    @recipe.ingredient = @recipe.ingredient.gsub(",", "\n")

    token = '' 

    uri = URI.parse("https://api.instagram.com/v1/tags/#{@recipe.name}/media/recent?access_token=#{token}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    @information = response.body
    @hash = JSON.parse(@information)


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @recipe }
    end

    

  end

  # GET /recipes/new
  # GET /recipes/new.json
  def new
    @recipe = Recipe.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @recipe }
    end
  end

  # GET /recipes/1/edit
  def edit
    @recipe = Recipe.find(params[:id])
  end

  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = Recipe.new(params[:recipe])

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
        format.json { render json: @recipe, status: :created, location: @recipe }
      else
        format.html { render action: "new" }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /recipes/1
  # PUT /recipes/1.json
  def update
    @recipe = Recipe.find(params[:id])

    respond_to do |format|
      if @recipe.update_attributes(params[:recipe])
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to recipes_url }
      format.json { head :no_content }
    end
  end
end

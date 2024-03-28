class HousesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_house, only: [:show, :edit, :update, :destroy]

  def index
    @houses = House.all
  end

  def show
    @house = House.find(params[:id])
  end

  def edit
  end

  def new
    @house = House.new
  end

  def create
    @house = House.new(house_params)
    @house.user = current_user
    authorize @house
    if @house.save
      redirect_to @house, notice: 'Maison créée avec succès.'
    else
      render :new
    end
  end

  def update
    authorize @house
    if @house.update(house_params)
      redirect_to @house, notice: 'Maison mise à jour avec succès.'
    else
      render :edit
    end
  end

  def destroy
    authorize @house
    @house.destroy
    redirect_to houses_path, notice: 'Maison supprimée avec succès.'
  end

  private

  def set_house
    @house = House.find(params[:id])
  end

  def house_params
    params.require(:house).permit(:title, :description, :price, images: [])
  end

end

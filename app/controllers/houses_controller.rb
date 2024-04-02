class HousesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_house, only: [:show, :edit, :update, :destroy]

  def index
    @houses = House.all
    @houses_with_address = House.geocoded.where.not(address: [nil, ""], city: [nil, ""], postal_code: [nil, ""])
  end

  def search
    @houses = House.all
    if params[:city].present?
      @houses = @houses.near(params[:city], params[:radius].to_f)
    end

    if params[:max_price].present?
      @houses = @houses.where("price <= ?", params[:max_price].to_f)
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("houses", partial: "houses/houses", locals: { houses: @houses })
      end
      format.html { render :index }
    end
  end

  def feature
    @house = House.find(params[:id])
    if @house.update(featured_params)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@house, partial: "houses/house", locals: { house: @house }) }
        format.html { redirect_to houses_path, notice: 'Maison mise à jour.' }
      end
    else
      render :show, status: :unprocessable_entity
    end
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
    # Vérifie s'il y a de nouvelles images à attacher
    if house_params[:images]
      @house.images.attach(house_params[:images])
    end

    # Mise à jour des autres attributs de @house sans les images
    if @house.update(house_params.except(:images))
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
    params.require(:house).permit(:title, :description, :price, :address, :city, :postal_code, :featured, :latitude, :longitude, images: [])
  end

  def featured_params
    params.require(:house).permit(:featured)
  end

end

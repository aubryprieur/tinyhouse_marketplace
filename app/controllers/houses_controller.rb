class HousesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_house, only: [:show, :edit, :update, :destroy, :validate]
  before_action :check_reported, only: [:show]
  before_action :set_houses, only: [:index, :search]


  def index
    @houses_with_address = @houses.geocoded.where.not(address: [nil, ""], city: [nil, ""], postal_code: [nil, ""])
  end

  def search
    filter_houses_by_params
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("houses", partial: "houses/houses", locals: { houses: @houses }) }
      format.html { render :index }
    end
  end

  def validate
    if current_user.super_admin? && !@house.validated?
      @house.update(validated: true)
      redirect_to admin_dashboard_path, notice: 'Maison validée et publiée.'
    else
      redirect_to admin_dashboard_path, alert: 'La validation de la maison a échoué.'
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
    @is_favorite = current_user.favorite_houses.exists?(@house.id)
  end

  def edit
  end

  def new
    @house = House.new
  end

  def create
    @house = House.new(house_params.except(:images))
    @house.user = current_user

    if @house.save
      if params[:house][:images] && params[:house][:images].size > 3
        redirect_to new_house_payment_path(@house)
      else
        redirect_to @house, notice: 'Maison créée avec succès.'
      end
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

  def set_houses
    base_query = House.all
    base_query = base_query.where.not(id: Report.where(resolved: false).select(:house_id)) unless current_user.super_admin?
    base_query = base_query.where(validated: true) unless current_user.super_admin?
    @houses = base_query
  end

  def filter_houses_by_params
    if params[:city].present?
      @houses = @houses.near(params[:city], params[:radius].to_f)
    end
    @houses = @houses.where("price <= ?", params[:max_price].to_f) if params[:max_price].present?
  end

  def house_params
    params.require(:house).permit(:title, :description, :price, :address, :city, :postal_code, :featured, :latitude, :longitude, images: [])
  end

  def featured_params
    params.require(:house).permit(:featured)
  end

  def check_reported
    if @house.reports.exists?(resolved: false) && !current_user.super_admin?
      redirect_to root_path, alert: "Cette maison a été signalée et n'est pas accessible."
    end
  end

  def filtered_houses
    if current_user.super_admin?
      House.all
    else
      House.includes(:reports).where.not(id: Report.where(resolved: false).select(:house_id))
    end
  end

  def filter_validated_houses
    @houses = current_user.super_admin? ? House.all : House.where(validated: true)
  end

end

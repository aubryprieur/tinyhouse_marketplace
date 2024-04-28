class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_house

  def create
    current_user.favorite_houses << @house
    redirect_to @house, notice: 'Added to favorites.'
  rescue ActiveRecord::RecordInvalid
    redirect_to @house, alert: 'Already in favorites.'
  end

  def destroy
    current_user.favorite_houses.delete(@house)
    redirect_to @house, notice: 'Removed from favorites.'
  end

  private

  def set_house
    @house = House.find(params[:house_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to houses_path, alert: 'House not found.'
  end
end

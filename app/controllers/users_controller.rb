class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:messages]

  def messages
    if current_user.super_admin?
      @houses = House.includes(:messages).all
    else
      @houses = current_user.houses.includes(:messages)
    end
  end

  def favorites
    @favorite_houses = current_user.favorites.includes(:house).map(&:house)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end




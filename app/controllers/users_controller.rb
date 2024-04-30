class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:messages]

  def messages
    if current_user.super_admin?
      @houses = House.includes(:messages).all
    else
      # Récupérer les identifiants des maisons pour lesquelles l'utilisateur a envoyé des messages
      sent_house_ids = current_user.messages.select(:house_id).distinct.pluck(:house_id)
      # Récupérer les identifiants des maisons pour lesquelles l'utilisateur a reçu des messages
      received_house_ids = Message.where(house: current_user.houses).select(:house_id).distinct.pluck(:house_id)
      # Union des deux ensembles d'identifiants
      all_house_ids = sent_house_ids | received_house_ids  # Utilisation de l'opérateur d'union des tableaux de Ruby
      # Récupération des maisons correspondant à ces identifiants
      @houses = House.includes(:messages).where(id: all_house_ids)
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




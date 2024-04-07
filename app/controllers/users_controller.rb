class UsersController < ApplicationController
  before_action :set_user, only: [:messages]

  def messages
    # Assurez-vous que seul l'utilisateur concerné ou un administrateur peut voir les messages
    authorize @user, :view_messages?
    # Récupère toutes les maisons de l'utilisateur
    @houses = @user.houses
    # Récupère tous les messages pour les maisons de l'utilisateur
    @messages = Message.includes(:user).where(house: @houses)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end


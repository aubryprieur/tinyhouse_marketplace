class MessagesController < ApplicationController
  before_action :set_house, only: [:new, :create]

  def new
    #@house = House.find(params[:house_id])  # Trouver la maison concernée
    @user = @house.user  # Récupérer le vendeur de la maison
    @message = Message.new
  end


  def create
    @message = @house.messages.new(message_params)
    @message.user = current_user

    if @message.save
      redirect_to house_path(@message.house), notice: "Votre message a été envoyé."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_house
    @house = House.find_by(id: params[:house_id])
    if @house.nil?
      redirect_to houses_path, alert: "Maison non trouvée."
    end
  end

  def message_params
    params.require(:message).permit(:content, :house_id)
  end
end

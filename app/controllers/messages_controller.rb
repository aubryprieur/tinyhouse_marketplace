class MessagesController < ApplicationController
  def new
    @house = House.find(params[:house_id])  # Trouver la maison concernée
    @user = @house.user  # Récupérer le vendeur de la maison
    @message = Message.new
  end


  def create
    @message = Message.new(message_params)
    @message.user = current_user  # Assumant que `current_user` est l'expéditeur du message
    @message.house_id = params[:house_id]  # Assurez-vous que `house_id` est passé correctement

    if @message.save
      redirect_to house_path(@message.house), notice: "Votre message a été envoyé."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :house_id)
    # Assurez-vous que :content est le nom de votre champ de texte dans le formulaire
  end

end

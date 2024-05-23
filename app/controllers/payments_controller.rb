class PaymentsController < ApplicationController
  before_action :set_house

  def new
    @amount = params[:amount]
  end

  def create
    token = params[:stripeToken]

    begin
      charge = Stripe::Charge.create({
        amount: 500, # 5€ en centimes
        currency: 'eur',
        description: 'Payment for extra photos',
        source: token
      })

      if charge.paid
        @house.update(payment_status: true, stripe_charge_id: charge.id)

        # Attacher les images après le paiement réussi
        if session[:pending_images]
          pending_images = session[:pending_images]
          attach_images(pending_images)
          session.delete(:pending_images)
        end

        redirect_to @house, notice: 'Payment successful and images attached!'
      else
        redirect_to new_house_payment_path(@house), alert: 'Payment failed!'
      end
    rescue Stripe::CardError => e
      redirect_to new_house_payment_path(@house), alert: e.message
    end
  end

  private

  def set_house
    @house = House.find(params[:house_id])
  end

  def attach_images(image_paths)
    image_paths.each do |image_path|
      image = File.open(image_path)
      @house.images.attach(io: image, filename: File.basename(image_path))
    end
  end
end



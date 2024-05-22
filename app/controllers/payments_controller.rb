class PaymentsController < ApplicationController
  before_action :set_house

  def new
    @amount = params[:amount]
  end

  def create
    # Assurez-vous de récupérer le token de Stripe
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
        redirect_to @house, notice: 'Payment successful!'
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
end

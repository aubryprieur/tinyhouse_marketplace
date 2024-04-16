class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_super_admin

  def dashboard
    @total_users = User.count
    @total_houses = House.count
    @average_price = House.average(:price).to_f.round(2)
  end

  private

  def ensure_super_admin
    redirect_to root_path, alert: "You are not authorized to view this page." unless current_user.super_admin?
  end
end


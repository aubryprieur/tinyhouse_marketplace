class ReportsController < ApplicationController
  before_action :authenticate_user!

  def create
    @house = House.find(params[:house_id])
    @report = @house.reports.create(user: current_user)
    redirect_to root_path, notice: "La maison a été signalée et sera révisée par un administrateur."
  end

  def resolve
    @report = Report.find(params[:id])
    @report.update(resolved: true)
    redirect_to admin_dashboard_path, notice: "Le signalement a été résolu."
  end
end


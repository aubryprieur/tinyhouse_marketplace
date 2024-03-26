class HousePolicy < ApplicationPolicy
  def create?
    user.super_admin? || user.seller?
  end

  def update?
    user.super_admin? || record.user == user
  end

  def destroy?
    update?
  end
end

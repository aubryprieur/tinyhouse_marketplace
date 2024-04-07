class UserPolicy < ApplicationPolicy
  def view_messages?
    user.super_admin? || record.id == user.id
  end
end

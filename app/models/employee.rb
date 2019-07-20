class Employee < ApplicationRecord
  module Roles
    CEO='ceo'
    VP='vp'
    DIRECTOR='director'
    MANAGER='manager'
    SDE='sde'
  end

  ROLES = Roles.constants.map{|c| Roles.const_get(c)}

  belongs_to :reporter, class_name: "Employee", foreign_key: :parent_id, optional: true
  has_many :reportees, class_name: "Employee", inverse_of: :reporter, foreign_key: :parent_id

  validates :email, uniqueness: true

  validate :check_for_top_level, if: :parent_id_changed?
  validate :valid_role?

  scope :active, -> { where(is_active: true) }

  ROLES.each do |role|
    scope role.to_sym, ->{ where(role: role) }
  end

  def valid_role?
    if ROLES.exclude?(self.role)
      self.errors[:role] << " can only have values (#{roles.join(', ')})."
    end
  end

  def check_for_top_level
    parent = Employee.find(self.parent_id) if self.parent_id
    if self.role == Roles::CEO && parent
      self.errors[:base] << "CEO should not report to anybody."
    end

    if parent && parent.role == Roles::SDE
      self.errors[:base] << "SDE is not allowed to have reportee under them."
    end
  end

  def parent
    emp = {}
    if self.reporter
      emp = self.reporter.as_json(except: [:created_at, :updated_at])
      emp['parent'] = self.reporter.parent if self.reporter
    end
    emp
  end

  def resign
    # all reportees under resignee should report to its reporter
    self.reportees.update_all({parent_id: self.parent_id})
    self.is_active = false
    self.parent_id = nil
    save
  end
end

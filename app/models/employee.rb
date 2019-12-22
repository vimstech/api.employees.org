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
  has_many :reportees, class_name: "Employee", foreign_key: :parent_id

  validates_uniqueness_of :email
  validates_presence_of :name, :role

  validate :check_for_top_level, if: :parent_id_changed?
  validate :valid_role?

  scope :active, -> { where(is_active: true) }

  ROLES.each do |role|
    scope role.to_sym, ->{ where(role: role) }
    define_method "is_#{role}".to_sym do
      return self.role == role
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
    self.transaction do
      self.reportees.update_all({parent_id: self.parent_id})
      self.update(is_active: false, parent_id: nil)
    end
  end

  protected
  def valid_role?
    if ROLES.exclude?(self.role)
      self.errors[:role] << " can only have values (#{ROLES.join(', ')})."
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
end

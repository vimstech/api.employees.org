class EmployeesController < ApplicationController
  before_action :find_employee, except: [:index, :create, :top, :search]

  def index
    employees = build_scope(Employee)
    render json: employees.as_json(json_attributes)
  end

  def search
    employees = Employee.where('role!="ceo" AND name LIKE ?', "%#{params[:search]}%")
    employees = build_scope(employees)
    render json: employees.as_json(json_attributes)
  end

  def top
    employees = Employee.where.not(role: 'ceo').order(salary: :desc).take(10)
    render json: employees.as_json(json_attributes)
  end

  def create
    employee = Employee.create(employee_params)
    if employee.valid?
      AddReporteesService.new(
        @employee, params[:employee][:reportees_attributes]
      ).call
      render json: employee.as_json(json_attributes), status: :ok
    else
      Rails.logger.error employee.errors.full_messages
      render json: employee.errors, status: :unprocessable_entity
    end
  end

  def update
    @employee.update_attributes(employee_params)
    if @employee.valid?
      AddReporteesService.new(
        @employee, params[:employee][:reportees_attributes]
      ).call
      render json: @employee.as_json(json_attributes), status: :ok
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end
  
  def show
    render json: @employee.as_json(json_attributes)
  end

  def resign
    if @employee.resign
      render json: @employee, status: :ok
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  def build_search scope, search_params
    scope.where('name ilike :name', name: "%${search_params[:name]}%")
  end

  private
  def find_employee
    @employee = Employee.find params[:id]
  end

  def employee_params
    params.require(:employee).permit(
      :name, :email, :salary, :role, :mobile, :rating, :role, :parent_id
    )
  end
end

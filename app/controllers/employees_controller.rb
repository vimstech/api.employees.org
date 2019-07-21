class EmployeesController < ApplicationController
  before_action :find_employee, except: [:index, :create, :top]

  def index
    employees = build_scope(Employee)
    render json: employees.as_json(json_attributes)
  end

  def top
    employees = Employee.where.not(role: 'ceo').order(salary: :desc).take(10)
    render json: employees.as_json(json_attributes)
  end

  def create
    employee = Employee.create(employee_params)
    if employee.valid?
      render json: employee.as_json(json_attributes), status: :ok
    else
      render json: employee.errors, status: :unprocessable_entity
    end
  end

  def update
    @employee.update(employee_params)
    if @employee.valid?
      render json: @employee.as_json(json_attributes), status: :ok
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end
  
  def show
    render json: @employee.as_json({
      methods: [:parent], except: [:created_at, :updated_at]
    })
  end

  def resign
    if @employee.resign
      render json: @employee, status: :ok
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  def search_params scope, search_params
    scope.where('name ilike :name', name: search_params[:name])
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

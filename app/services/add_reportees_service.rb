class AddReporteesService
  attr_reader :reporter, :reportees_attributes
  def initialize reporter, reportees_attributes
    @reportees_attributes = reportees_attributes
    @reporter = reporter
  end

  def call
    return if reporter.nil? || reportees_attributes.nil?
    return if reporter.is_sde?
    assign_reportees
  end

  def assign_reportees
    reportees = Employee.where(
      email: reportees_attributes.map(&:to_s),
      is_active: true
    )

    reportees.each do |reportee|
      reportee.parent_id = reporter.id
      reportee.save
    end
  end
end
def create_emaployee role, parent_id
  emp = Employee.create(
    name: FFaker::NameIN.name,
    email: FFaker::Internet.email,
    salary: SecureRandom.random_number.to_s[2..8],
    mobile: FFaker::PhoneNumber.short_phone_number,
    role: role,
    parent_id: parent_id,
    rating: rand(1..5)
  )
  puts "#{emp.id}, #{parent_id}"
end

Employee.where(role: Employee::Roles::MANAGER).pluck(:id).each do |id|
  5.times.each do |i|
    create_emaployee Employee::Roles::SDE, id
  end
end

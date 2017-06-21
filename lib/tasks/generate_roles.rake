desc 'Generate default Donut roles'
task generate_roles: :environment do
  ['admin'].each do |role|
    puts "Generating role #{role}"
    Role.where(name: role).first_or_create
  end
end

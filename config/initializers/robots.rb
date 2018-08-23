# Picks which robot we should use
robot_file = 'no_robots.txt'
robot_file = 'prod_robots.txt' if Rails.env == 'production'
src_path = Pathname.new(Rails.root.to_s + "/public/#{robot_file}")
target_path = Pathname.new(Rails.root.to_s + '/public/robots.txt')
FileUtils.cp src_path, target_path

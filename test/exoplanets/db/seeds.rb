
%w(admin).each do |k|
  Role.create name: k
end

%w(cedric.nehemie).each do |k|
  User.create do |s|
    s.email = "#{k}@gmail.fr"
    s.password = ENV['DEFAULT_PASSWORD']
    s.password_confirmation = ENV['DEFAULT_PASSWORD']
    s.first_name = k.split('.').map(&:capitalize).first
    s.last_name = k.split('.').map(&:capitalize).last
    s.add_role :admin
  end
end


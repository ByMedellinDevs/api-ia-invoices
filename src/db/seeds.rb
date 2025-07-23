# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create a default user for testing
user = User.find_or_create_by(email: 'admin@example.com') do |u|
  u.name = 'Admin User'
  u.password = 'password123'
  u.password_confirmation = 'password123'
end

puts "Created user: #{user.email}"

# Create a default OAuth application
app = Doorkeeper::Application.find_or_create_by(name: 'API Client') do |application|
  application.uid = 'api_client_uid'
  application.secret = 'api_client_secret'
  application.redirect_uri = 'urn:ietf:wg:oauth:2.0:oob'
  application.scopes = 'public write'
end

puts "Created OAuth application: #{app.name}"
puts "Client ID: #{app.uid}"
puts "Client Secret: #{app.secret}"
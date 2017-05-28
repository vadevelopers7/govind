require 'highline/import'
namespace :user do
  desc "Create an admin user"
  task admin: :environment do
    first_name = ask("First Name : ") {|q| q.echo = true }
    last_name = ask("Last Name : ") {|q| q.echo = true }
    mobile = ask("Mobile : ") {|q| q.echo = true }
    username = ask("Username : ") {|q| q.echo = true }
    email = ask("Email :  ") { |q| q.echo = true }
    password = ask("Password :  ") { |q| q.echo = "*" }
    begin
      User.create!(first_name: first_name, last_name: last_name, mobile: mobile, username: username, email: email, password: password, role: 'admin')
    rescue => e
      puts "Unable to create admin user due to following errors"
      puts e.message
    end
  end

end

# This file should contain all the record creation needed to seed the database with its default
# values. The data can then be loaded with the rake db:seed (or created alongside the db with
# db:setup).

# Users
# Create 3 users: super_admin, sign_owner, non_sign_owner
User.destroy_all

# Skip authentication: http://stackoverflow.com/a/21169179/6763239
super_admin = User.new(email: 'super_admin@chapman.edu',
                       first_name: 'Super',
                       last_name: 'Admin')
super_admin.role = :super_admin
super_admin.save!

User.create!(email: 'sign_owner@chapman.edu', first_name: 'Sign', last_name: 'Owner')
User.create!(email: 'non_sign_owner@chapman.edu', first_name: 'Non', last_name: 'Owner')

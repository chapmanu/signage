# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

james = User.where(email: 'jkerr@chapman.edu').first_or_initialize
james.first_name = 'James'
james.last_name  = 'Kerr'
james.roll = :super_admin
james.save

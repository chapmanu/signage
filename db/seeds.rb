# This file should contain all the record creation needed to seed the database with its default
# values. The data can then be loaded with the rake db:seed (or created alongside the db with
# db:setup).

#
# Reset
#
User.destroy_all
Sign.destroy_all
PublicActivity::Activity.destroy_all
Slide.destroy_all

#
# Users
# Create 3 users: super_admin, sign_owner, non_sign_owner
#
# Skip authentication: http://stackoverflow.com/a/21169179/6763239
super_admin = User.new(email: 'super_admin@chapman.edu',
                       first_name: 'Super',
                       last_name: 'Admin')
super_admin.role = :super_admin
super_admin.save!

sign_owner = User.create!(email: 'sign_owner@chapman.edu', first_name: 'Sign', last_name: 'Owner')
non_sign_owner = User.create!(email: 'non_sign_owner@chapman.edu', first_name: 'Non', last_name: 'Owner')


#
# Signs
# Create 2 signs for sign_owner: 1 public and 1 private
#
private_sign = Sign.new(name: 'A Private Sign',
                        template: 'default',
                        location: 'The mind of a child.',
                        visibility: Sign.visibilities[:hidden])
private_sign.owners << sign_owner
private_sign.save!
private_sign.create_activity(:create, owner: sign_owner, parameters: { name: private_sign.name })

public_sign = Sign.new(name: 'A Public Sign',
                        template: 'default',
                        location: 'Totally out there for everyone to see!',
                        visibility: Sign::visibilities[:listed])
public_sign.owners << sign_owner
public_sign.save!
public_sign.create_activity(:create, owner: sign_owner, parameters: { name: public_sign.name })


#
# Slides and Notifications
# Create 4 slides:
# - 1 by sign_owner for both signs
# - 1 by non_sign_owner for sign_owner sign that is approved by sign owner
# - 1 that is not approved by sign owner
# - 1 that is expired
#
# Sign Owner's adds slide to both her signs.
sign_owners_slide = Slide.create!(name: "Sign Owner's Slide",
                                   template: 'standard',
                                   menu_name: 'Sign Owner Slide',
                                   heading: 'Slide by Sign Owner',
                                   subheading: 'My slide for my signs',
                                   datetime: Time.zone.now)
sign_owners_slide.create_activity(:create,
                                  owner: sign_owner,
                                  parameters: { name: sign_owners_slide.menu_name })
sign_owner.slides << sign_owners_slide
UpdateSlide.execute(sign_owners_slide, {sign_ids: [private_sign.id]}, sign_owner)
UpdateSlide.execute(sign_owners_slide, {sign_ids: [public_sign.id]}, sign_owner)

# Non Owner creates two slides and requests they be added to Owner's sign.
unapproved_slide = Slide.create!(name: 'Unapproved Sign',
                                 template: 'standard',
                                 menu_name: 'MA',
                                 heading: 'Mature Audiences Only')
unapproved_slide.create_activity(:create,
                                 owner: non_sign_owner,
                                 parameters: { name: unapproved_slide.menu_name })
non_sign_owner.slides << unapproved_slide
non_sign_owner.save!
UpdateSlide.execute(unapproved_slide, {sign_ids: [public_sign.id]}, non_sign_owner)

approved_slide = Slide.create!(name: 'Approved Slide',
                               template: 'standard',
                               menu_name: 'Approved Slide',
                               heading: 'A Publicly Approved Slide')
approved_slide.create_activity(:create,
                               owner: non_sign_owner,
                               parameters: { name: approved_slide.menu_name })
non_sign_owner.slides << approved_slide
non_sign_owner.save!
UpdateSlide.execute(approved_slide, {sign_ids: [public_sign.id]}, non_sign_owner)

# Sign Owner approves approved sign.
approved_slide.sign_slides.first.update(approved: true)
public_sign.touch
UserMailer.sign_slide_approved(sign_slide: approved_slide.sign_slides.first,
                               approver: sign_owner,
                               message: 'I approve this sign!').deliver_now

# Non Owner create slide that has expired
expired_slide = Slide.create!(name: 'Expired Slide',
                              template: 'standard',
                              menu_name: 'Expired Slide',
                              heading: 'This slide died alone and unloved.',
                              play_on: Time.zone.now - 5.days,
                              stop_on: Time.zone.now - 2.days)
expired_slide.create_activity(:create,
                              owner: non_sign_owner,
                              parameters: { name: approved_slide.menu_name })
non_sign_owner.slides << expired_slide
non_sign_owner.save!
UpdateSlide.execute(expired_slide, {sign_ids: [public_sign.id]}, non_sign_owner)
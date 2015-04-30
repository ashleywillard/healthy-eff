# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# ===== Seed the Reimbursement Rate - THIS MUST BE HERE OR APP WILL FAIL === #
Constant.create! :curr_rate => 10

# ===== Admin account ===== #
user = User.create! :first_name => 'Admin',
                    :last_name => 'Test',
                    :email => '169.healthyeff@gmail.com',
                    :password => '?Northsidepotato169',
                    :password_confirmation => '?Northsidepotato169',
                    :password_changed => true
# Manually give admin privileges, since attr_protected
user.admin = true
user.save

# ===== Non-admin account ===== #
User.create! :first_name => 'User',
             :last_name => 'Test',
             :email => 'healthypotato@gmail.com', 
             :password => '?Hotpotato169', 
             :password_confirmation => '?Hotpotato169',
             :password_changed => true


# ===== EFF Admin Below ===== #

admin = User.create! :first_name => 'Maggie',
                    :last_name => 'Utgoff',
                    :email => 'mutgoff@eff.org',
                    :password => 'Testing1?',
                    :password_confirmation => 'Testing1?',
                    :password_changed => true
# Manually give admin privileges, since attr_protected
admin.admin = true
admin.save!


# ===== EFF Employees Below ===== #
User.create! :first_name => 'Aaron',
             :last_name => 'Jue',
             :email => 'aaron@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Adi',
             :last_name => 'Kamdar',
             :email => 'adi@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Alison',
             :last_name => 'Dame-Boyle',
             :email => 'alison@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Amul',
             :last_name => 'Kalia',
             :email => 'amul@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Andrea',
             :last_name => 'Chiang',
             :email => 'andrea@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Andrew',
             :last_name => 'Crocker',
             :email => 'andrew@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Ben',
             :last_name => 'Burke',
             :email => 'ben@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'William',
             :last_name => 'Budington',
             :email => 'bill@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Cindy',
             :last_name => 'Cohn',
             :email => 'cindy@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Cooper',
             :last_name => 'Quintin',
             :email => 'cooperq@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Cory',
             :last_name => 'Not Online',
             :email => 'cory@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Corynne',
             :last_name => 'McSherry',
             :email => 'corynne@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Cristina',
             :last_name => 'Rosales',
             :email => 'cristina@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Daniel',
             :last_name => 'Nazer',
             :email => 'daniel@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Danny',
             :last_name => 'O\'Brien',
             :email => 'danny@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'David',
             :last_name => 'Greene',
             :email => 'davidg@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Dave',
             :last_name => 'Maass',
             :email => 'dm@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Eva',
             :last_name => 'Galperin',
             :email => 'eva@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Hanni',
             :last_name => 'Fakhoury',
             :email => 'hanni@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Hugh',
             :last_name => 'D\'Andrade',
             :email => 'hugh@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Jamie',
             :last_name => 'Lee Williams',
             :email => 'jamie@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Mark',
             :last_name => 'Jaycox',
             :email => 'jaycox@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Not',
             :last_name => 'Online',
             :email => 'jcb@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Jeremy',
             :last_name => 'Gillula',
             :email => 'jeremy@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Jennifer',
             :last_name => 'Lynch',
             :email => 'jlynch@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Jeremy',
             :last_name => 'Malcolm',
             :email => 'jmalcolm@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Joanna',
             :last_name => 'Cullom',
             :email => 'joanna@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Jacob',
             :last_name => 'Hoffman-Andrews',
             :email => 'jsha@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Not',
             :last_name => 'Online',
             :email => 'jstyre@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Karen',
             :last_name => 'Gullo',
             :email => 'karen@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Katitza',
             :last_name => 'Rodriguez',
             :email => 'katitza@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Kelly',
             :last_name => 'Esguerra',
             :email => 'kelly@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Keri',
             :last_name => 'Crist',
             :email => 'keri@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Kim',
             :last_name => 'Carlson',
             :email => 'kim@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Kit',
             :last_name => 'Walsh',
             :email => 'kit@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Kurt',
             :last_name => 'Opsahl',
             :email => 'kurt@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Laura',
             :last_name => 'Lemus',
             :email => 'laura@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Lisa',
             :last_name => 'Wright',
             :email => 'leez@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Madeleine',
             :last_name => 'Mulkern',
             :email => 'madeleine@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Magdalena',
             :last_name => 'Kamierczak',
             :email => 'maggie@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Maira',
             :last_name => 'Sutton',
             :email => 'maira@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Mark',
             :last_name => 'Rumold',
             :email => 'mark@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Max',
             :last_name => 'Hunter',
             :email => 'max@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Mark',
             :last_name => 'Burdett',
             :email => 'mfb@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Michael',
             :last_name => 'Not Online',
             :email => 'michael@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Mitch',
             :last_name => 'Stoltz',
             :email => 'mitch@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Nadia',
             :last_name => 'Kayyali',
             :email => 'nadia@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Nate',
             :last_name => 'Cardozo',
             :email => 'nate@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Nicole',
             :last_name => 'Puller',
             :email => 'nicole@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Noah',
             :last_name => 'Swartz',
             :email => 'noah@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Parker',
             :last_name => 'Higgins',
             :email => 'parker@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Peter',
             :last_name => 'Eckersley',
             :email => 'pde@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Rainey',
             :last_name => 'Reitman',
             :email => 'rainey@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Rebecca',
             :last_name => 'Jeschke',
             :email => 'rebecca@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Richard',
             :last_name => 'Esguerra',
             :email => 'richard@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Seth',
             :last_name => 'Schoen',
             :email => 'schoen@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'David',
             :last_name => 'Sobel',
             :email => 'sobel@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Sophia',
             :last_name => 'Cope',
             :email => 'sophia@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Starchy',
             :last_name => 'Grant',
             :email => 'starchy@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Stephanie',
             :last_name => 'Shattuck',
             :email => 'steph@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Tammy',
             :last_name => 'McMillen',
             :email => 'tammy@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Not',
             :last_name => 'Online',
             :email => 'tien@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Jeremy',
             :last_name => 'Tribby',
             :email => 'tribby@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'Vera',
             :last_name => 'Ranieri',
             :email => 'vera@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true

User.create! :first_name => 'William',
             :last_name => 'Theaker',
             :email => 'william@eff.org', 
             :password => 'Testing1?', 
             :password_confirmation => 'Testing1?',
             :password_changed => true
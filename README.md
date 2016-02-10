# Digital Signage 2.0

![Codeship](https://codeship.com/projects/d35abc40-275e-0133-fc89-7af7072ae828/status?branch=master)

### Set up
```
git clone https://github.com/chapmanu/signage.git
cd signage
touch .env
# Ask a team member for the environment variables
bundle install
rake db:create db:migrate
rake cascade:sync
rails s
```

Then head over to [localhost:3000](http://localhost:3000)

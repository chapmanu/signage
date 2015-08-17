# Digital Signage 2.0

### Set up
```
git clone https://github.com/chapmanu/signage.git
cd signage
bundle install
rake db:create db:migrate
rake cascade:sync
rails s
```

Then head over to [localhost:3000](http://localhost:3000)
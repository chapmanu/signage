# Chapman University Digital Signage 2.0

### Set up
```
git clone https://github.com/chapmanu/digital-signage-2.git
cd digital-signage-2
bundle install
rake db:create db:migrate
rake cascade:sync
rails s
```

Then head over to [localhost:3000](http://localhost:3000)

# Setup

1. Make sure you have ruby 3.2.1 installed. Use rbenv or rvm for managing ruby versions.
2. Make sure you have the 5432 & 6379 ports free for postgres and redis.
3. Run `docker-compose up -d`.
4. Run `bundle install`.
5. Run `bundle exec rspec` to ensure tests are working.
6. Optional, but recommended: run `bundle exec overcommit --install` to make sure you have the overcommit hooks installed.

This app is API only. Once you run `rails server`, it will listen by default on port 3000. You can communicate with the API through HTTP requests (like using postman).

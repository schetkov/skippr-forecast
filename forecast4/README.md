[![Code Climate](https://codeclimate.com/repos/558221db695680214801c634/badges/ef5fab4f749f59d98e75/gpa.svg)](https://codeclimate.com/repos/558221db695680214801c634/feed)
[![Test Coverage](https://codeclimate.com/repos/558221db695680214801c634/badges/ef5fab4f749f59d98e75/coverage.svg)](https://codeclimate.com/repos/558221db695680214801c634/coverage)
[![Circle CI](https://circleci.com/gh/patcrivelli/ix.svg?style=svg&circle-token=686ddd300d36fcc58fe6515b3e046655a131a1d6)](https://circleci.com/gh/patcrivelli/ix)

## IX

The InvoiceExchange is a Rails 4.2.2 app using Ruby 2.2.0 and deployed to Heroku.

## Development

### Rules of the road

This project attempts to follow the rules set by Sandi Metz.

You can read a [description of the rules here](http://robots.thoughtbot.com/post/50655960596/sandi-metz-rules-for-developers).

All new code should follow these rules. 

If you make changes in a pre-existing file that violates these rules you should fix the violations as part of your work.

### Setup

1. Get the code

        % git clone git@github.com:patcrivelli/ix.git
    
2. Set up your environment

        % bin/setup
    
3. Ask for environment variables and update your `.env`

        % vim .env
  
4. Start Foreman

        % foreman start

5. Verify the app is up and running

        % open http://localhost:5000
  
### Protocol

1. Look for cards in the **Next Up** list.
2. When you start a card, add yourself and move the card to the **In Progress**
   list.
3. When opening a pull request, move the card to the **Code Review** list and
   ask in Slack for a review.
4. Once the review is complete, merge into master as usual. Wait for CI to
   finish running the build.
5. Once CI is finished running the build, it will deploy to staging. Move the
   card to **On Staging for acceptance** at this time. Comment on the card with
  acceptance instructions. Include a URL to staging. Ask in Slack for
  acceptance.

### Continuous Integration

CI is hosted with [Circle CI](https://circleci.com/gh/ralphos/ix). The
build is run automatically whenever any branch is updated on Github.

### Ongoing

* Run test suite before committing to the master branch.

        % rake

* Dump production data into your local db. (Note that you need to drop your
  local database first).

        % rake db:drop
        % heroku pg:pull DATABASE_URL invoice_exchange_development -r production
        
### Deployment

        % git push staging master
        
        % git push production master
        
### Sending email on staging

*TODO: add email interceptor and detail instructions on how to set up*

### Admin Access

After running `bin/setup`, two admin users should have been created. You can
find their login credentials in `lib/tasks/admin_users.rake`.

If not, you can try and run the rake task again.

        % rake admin:create_admin_users

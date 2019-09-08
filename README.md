## Information

Simple user registration/authentication system using Postgres db. 
This authentication solution was created avoinding the usage of third party libraries as Devise authentication.
As an user you will be able to:
- create an account
- edit user profile (username and password)
- reset the password in case it was forgotten

## Getting started

Clone user registration code base:

```console
$ git clone https://github.com/mdasrafael/user_registration
```

Create files for each environment to store secret environment variables.
The required ones are EMAIL, SECRET_KEY_BASE and USER_REGISTRATION_DATABASE_PASSWORD as follows: 

`config/development.yml`
```ruby
EMAIL: [YOUR EMAIL OF CHOICE]
SECRET_KEY_BASE: [YOUR ENVIRONMENT SECRET KEY BASE]
USER_REGISTRATION_DATABASE_PASSWORD: [YOUR POSTGRES DATABASE PASSWORD]
```
Create database
```ruby
rails db:create RAILS_ENV=[YOUR ENVIRONMENT OF CHOICE]
```

Run migrations
```ruby
rails db:migrate RAILS_ENV=[YOUR ENVIRONMENT OF CHOICE]
```

FactoryBot.define do
  factory :user do
    username { 'TestUser' }
    sequence(:email) { |n| "example#{n}@example.com" }
    password { 'easyplease' }
    password_confirmation { 'easyplease' }

    factory :user_with_old_reset_password_token do
      reset_password_token { SecureRandom.hex(10) }
      reset_password_sent_at {  Time.now.utc - 7.hours }
    end
  end
end
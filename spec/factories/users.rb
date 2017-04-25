FactoryGirl.define do
  sequence :email do |n|
    "test#{n}@yopmail.com"
  end
  sequence :username do |n|
    "test#{n}"
  end
  factory :user do
    first_name "foo"
    last_name "bar"
    username
    mobile "9785356441"
    email
    password "1234567890"
    role "shopper"
  end
end

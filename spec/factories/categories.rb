FactoryGirl.define do
  factory :category do
    city nil
    sequence_id 1
    name "Laptop"
    icon "fa-laptop"
    description "Slim laptops"
    display_home_status true
    meta_title "laptop"
    meta_keyword "computer"
    meta_description "Slim laptops"
    active true
  end
end

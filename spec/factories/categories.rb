FactoryGirl.define do
  factory :category do
    sub_main_category nil
    sequence_id 1
    name "Smart Phone"
    description "Android"
    display_home_status true
    meta_title "Smart Phone"
    meta_keyword "Mobile"
    meta_description "Android"
    active true
  end
end

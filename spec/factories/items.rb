FactoryGirl.define do
  factory :item do
    category nil
    user nil
    name "A"
    model_no "A1"
    price "10.50"
    discount "10.0"
    color "blue"
    display_stock_out true
    active true
    inventory 10
    description "text"
    image_0 "abc"
    image_1 "def"
    image_2 "ghi"
    meta_title "string"
    meta_keyword "string"
    meta_description "text"
    average_rating "0.0"
    review_count 0
  end
end

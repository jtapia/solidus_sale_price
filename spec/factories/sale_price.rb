FactoryGirl.define do
  factory :sale_price, class: Spree::SalePrice do
    price
    value 10
    start_at Date.today
    enabled true

    factory :disabled do
      after :create do |sale_price|
        sale_price.disable
      end
    end
  end
end
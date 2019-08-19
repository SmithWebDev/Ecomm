categories = Category.create([
  {name: "Computers"},
  {name: "Smart Phones"},
  {name: "Televisions"},
  {name: "Game Consoles"},
  {name: "Video Games"},
  {name: "Appliances"},
  {name: "other"},
]),
50.times do
  Product.create!(
    name: Faker::Commerce.product_name,
    price: Faker::Commerce.price,
    quantity: rand(100),
    description: Faker::Lorem.sentences.to_s,
    brand: Faker::Appliance.brand,
    rating: rand(10),
    category_id: rand(1..7)
  )
end
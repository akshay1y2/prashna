namespace :packs do
  desc 'seed some purchase-packs to database.'
  task seed: :environment do
    PurchasePack.create(
      pack_type: :single,
      name: "Single-Credit-Pack",
      credits: 1,
      original_price: 0.1e1,
      current_price: 0.7e0,
      image: "only_one",
      description: "Single credit pack gives you one credit, which you can use when the credits fall short",
      enabled: true
    )
    PurchasePack.create(
      pack_type: :combo,
      name: "Small-Combo-Pack",
      credits: 5,
      original_price: 0.5e1,
      current_price: 0.35e1,
      image: "combo1",
      description: "Combo Pack of five credits, now you can ask some qestions and maybe more!", 
      enabled: true
    )
    PurchasePack.create(
      pack_type: :combo,
      name: "Big-Combo-Pack",
      credits: 12,
      original_price: 0.1e2,
      current_price: 0.8e1,
      image: "combo2",
      description: "Combo Pack of 12 credits, This pack is big, as big as your curiosity!", 
      enabled: true
    )
    PurchasePack.create(
      pack_type: :default,
      name: "Sign-Up-Pack",
      credits: 5,
      original_price: 0.5e1,
      current_price: 0.0,
      image: "free",
      description: "Welcome Pack, offers free credits at signup to start with. Enjoy!", 
      enabled: true
    )
    puts '='*10, 'Done'
  end
end

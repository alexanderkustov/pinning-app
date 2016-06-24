FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "coder#{n}@skillcrush.com" }
    first_name "Skillcrush"
    last_name "Coder"
    password "secret"

    after(:create) do |user|
      3.times do
        user.pinnings.create(pin: FactoryGirl.create(:pin))
      end
    end
  end

  factory :pin do
    title "Rails Cheatsheet"
    url "http://rails-cheat.com"
    text "A great tool for beginning developers"
    category Category.find_by_name("rails")
    sequence :slug do |n|
      "slug#{n}"
    end
  end

  factory :pinning do
    pin
    user
  end

end

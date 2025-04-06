FactoryBot.define do
  factory :tutor_time do
    association :user
    association :task
    time_spent { 120.0 }
  end
end

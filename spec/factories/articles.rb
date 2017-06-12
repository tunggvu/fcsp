FactoryGirl.define do
  factory :article do
    title{FFaker::Book.title}
    description{FFaker::Book.description}
    content{FFaker::Lorem.paragraphs}
    time_show{Time.zone.now}
    user_id 2
    company_id 1
  end
end

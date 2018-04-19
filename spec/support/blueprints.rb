require 'machinist/active_record'

Payment.blueprint do
  transaction_id { "transaction#{sn}" }
  amount { 20 }
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  email { "user#{ sn }@camplify.com" }
end
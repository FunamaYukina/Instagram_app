class User < ApplicationRecord
  validates :name,{ presence:true }
  validates :full_name,{presence:true}
  validates :email,{ presence:true, uniqueness:true }
end

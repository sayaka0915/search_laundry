class Laundry < ApplicationRecord
  # belongs_to :user
  has_many :comments
  with_options presence: true do
    validates :name
    validates :address
    validates :opening_date
    validates :open_time
    validates :close_time
  end
  with_options inclusion: {in: [true, false]} do
    validates :shoe_washing
    validates :futon_washing
    validates :dryer
    validates :washing_machine
  end
end

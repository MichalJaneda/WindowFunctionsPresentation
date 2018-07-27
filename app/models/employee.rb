class Employee < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true

  belongs_to :leader,
             class_name: 'Employee',
             optional: true

  has_many :paychecks
  has_many :sales, foreign_key: :seller_id
end

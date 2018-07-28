require 'rails_helper'

RSpec.describe ProductsSales, type: :model do
  subject { build(:products_sales) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }

    it { is_expected.to validate_uniqueness_of(:sale_id).scoped_to(:product_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to belong_to(:sale) }
  end
end

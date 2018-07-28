require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:for_sale_since) }

    it { is_expected.to monetize(:price_net) }
    it { is_expected.to validate_numericality_of(:price_net).is_greater_than(0) }

    it { is_expected.to monetize(:price_with_tax) }
    it { is_expected.to validate_numericality_of(:price_with_tax).is_greater_than(0) }
  end

  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:types).class_name('ProductType') }
    it { is_expected.to have_many(:sales).through(:products_sales) }
  end
end

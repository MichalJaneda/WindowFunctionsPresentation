require 'rails_helper'

RSpec.describe Sale, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:sold_on) }

    it { is_expected.to monetize(:discount) }
    it { is_expected.to validate_numericality_of(:discount).is_greater_than_or_equal_to(0) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:client) }
    it { is_expected.to belong_to(:seller).class_name('Employee') }

    it { is_expected.to have_many(:products_sales) }
    it { is_expected.to have_many(:products).through(:products_sales) }
  end
end

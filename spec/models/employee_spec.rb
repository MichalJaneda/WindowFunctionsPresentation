require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:leader).class_name(described_class) }
    it { is_expected.to have_many(:paychecks) }
    it { is_expected.to have_many(:sales).with_foreign_key(:seller_id) }
  end
end

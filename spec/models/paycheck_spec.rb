require 'rails_helper'

RSpec.describe Paycheck, type: :model do
  subject { build(:paycheck) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:paid_on) }

    it { is_expected.to validate_presence_of(:year) }
    it { is_expected.to validate_numericality_of(:year).is_greater_than_or_equal_to(1970).only_integer }

    it { is_expected.to validate_presence_of(:month) }
    it { is_expected.to validate_numericality_of(:month).is_greater_than_or_equal_to(1).is_less_than_or_equal_to(12).only_integer }

    it { is_expected.to monetize(:payment) }
    it { is_expected.to validate_numericality_of(:payment).is_greater_than(0) }

    it { is_expected.to monetize(:bonus) }
    it { is_expected.to validate_numericality_of(:bonus).is_greater_than_or_equal_to(0) }

    it { is_expected.to validate_uniqueness_of(:employee_id).scoped_to(:month, :year) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:employee) }
    it { is_expected.to belong_to(:position) }
  end
end

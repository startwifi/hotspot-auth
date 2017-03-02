describe Statistic, type: :model do
  describe 'associations' do
    it { should belong_to(:company) }
    it { should belong_to(:user) }
  end
end

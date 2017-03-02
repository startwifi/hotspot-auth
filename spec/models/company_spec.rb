describe Company, type: :model do
  describe 'associations' do
    it { should have_many(:devices) }
    it { should have_many(:events) }
    it { should have_many(:users) }
    it { should have_many(:statistics) }

    it { should have_one(:fb) }
    it { should have_one(:guest) }
    it { should have_one(:in) }
    it { should have_one(:ok) }
    it { should have_one(:sms) }
    it { should have_one(:tw) }
    it { should have_one(:vk) }
  end
end

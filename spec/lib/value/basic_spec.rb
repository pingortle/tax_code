describe Value::Basic do
  subject { described_class.new value }
  let(:value) { 1000 }

  describe '#value' do
    subject { super().value }
    it { is_expected.to eq value }
  end
end

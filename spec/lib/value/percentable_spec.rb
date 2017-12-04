describe Value::Percentable do
  subject { described_class.new Value::Basic.new(value), percentage: percentage }
  let(:value) { 1000 }
  let(:percentage) { 50 }

  describe '#value' do
    subject { super().value }
    it { is_expected.to eq value / 2 }
  end
end

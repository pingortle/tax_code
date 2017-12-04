describe Value::Adjustable do
  subject { described_class.new TaxCode::Value::Basic.new(value), adjustment: adjustment }
  let(:value) { 1000 }
  let(:adjustment) { 10 }

  describe '#value' do
    subject { super().value }
    it { is_expected.to eq value + adjustment }
  end
end

describe TaxCode::Salary do
  subject { described_class.new gross: gross }

  describe 'new' do
    context 'with gross less than zero' do
      let(:gross) { -1 }
      it { expect { subject }.to raise_error(ArgumentError) }
    end
  end

  describe '#value' do
    subject { super().value }
    let(:gross) { rand(1_000_000) }
    it { is_expected.to eq gross }
  end
end

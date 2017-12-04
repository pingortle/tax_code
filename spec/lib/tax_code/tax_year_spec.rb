describe TaxCode::TaxYear do
  subject { described_class.new TaxCode::Value::Basic.new(salary), brackets }

  let(:salary) { 1_000_000 }
  let(:brackets) { [from: from, to: to, percentage: percentage] }
  let(:from) { 0 }
  let(:to) { from + 1000 }
  let(:size) { to - from }
  let(:percentage) { 50 }
  let(:factor) { percentage / 100.0 }

  describe '#value' do
    subject { super().value }

    it { is_expected.to eq size * factor  }

    context 'with multiple brackets' do
      let(:offset) { size }
      let(:second_percentage) { 25 }
      let(:second_factor) { second_percentage / 100.0 }
      let(:brackets) { super() + [from: from + offset, to: to + offset, percentage: second_percentage] }

      it { is_expected.to eq size * factor + size * second_factor }
    end
  end
end

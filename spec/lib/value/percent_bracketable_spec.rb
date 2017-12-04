describe Value::PercentBracketable do
  subject do
    described_class.new Value::Basic.new(value),
      from: from,
      to: to,
      percentage: percentage
  end

  let(:percentage) { 50 }
  let(:factor) { percentage / 100.0 }
  let(:from) { 10 }
  let(:to) { from + 10 }
  let(:size) { to - from }
  let(:lesser_value) { from - 1 }
  let(:inner_value) { from + inner_offset }
  let(:greater_value) { to + 1 }
  let(:inner_offset) { size / 2 }
  let(:any_value) { rand(1000) }

  describe 'new' do
    let(:value) { any_value }

    context 'with from less than zero' do
      let(:from) { -1 }
      it { expect { subject }.to raise_error(ArgumentError) }
    end

    context 'with to less than zero' do
      let(:to) { -1 }
      it { expect { subject }.to raise_error(ArgumentError) }
    end

    context 'with to less than from' do
      let(:to) { from - 1 }
      it { expect { subject }.to raise_error(ArgumentError) }
    end
  end

  describe '#value' do
    subject { super().value }

    context 'with a lesser value' do
      let(:value) { lesser_value }
      it { is_expected.to eq 0 }
    end

    context 'with a greater value' do
      let(:value) { greater_value }
      it { is_expected.to eq size * factor }
    end

    context 'with a value inside the bracket' do
      let(:value) { inner_value }
      it { is_expected.to eq inner_offset * factor }
    end
  end
end

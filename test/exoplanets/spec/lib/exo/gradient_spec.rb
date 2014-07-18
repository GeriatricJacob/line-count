require 'spec_helper'

describe Exo::Gradient do
  context 'created with colors and positions' do
    let(:color_1) { Exo::Color.new hex: 0x000000 }
    let(:color_2) { Exo::Color.new hex: 0xffffff }
    let(:color_3) { Exo::Color.new hex_argb: 0x00000000 }
    let(:colors) { [ color_1, color_2, color_3 ] }
    let(:positions) { [0.0, 0.4, 1.0] }

    let(:gradient) { Exo::Gradient.new colors: colors, positions: positions }

    describe '#at' do
      context 'with 0.2' do
        subject { gradient.at 0.2 }

        it { should be_a_color 127, 127, 127, 255 }
      end

      context 'with 0.7' do
        subject { gradient.at 0.7 }

        it { should be_a_color 127, 127, 127, 127 }
      end

    end
  end
end

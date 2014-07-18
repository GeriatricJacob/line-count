require 'spec_helper'

describe Exo::Color do
  all_options = [
    { red: 255, green: 0, blue: 0, alpha: 255 },
    { rgba: [255,0,0,255] },
    { rgb: [255, 0, 0] },
    { hex: 0xff0000 },
    { hex_argb: 0xffff0000 },
    { html: '#ff0000' },
    { html_argb: '#ffff0000' },
    { css_rgb: 'rgb(255,0,0)'},
    { css_rgba: 'rgba(255,0,0,1)'},
    { pixel: Magick::Pixel.new(Magick::QuantumRange, 0, 0, 0) },
  ]

  all_options.each do |options|
    context "created with #{options.keys.to_sentence} option" do
      subject { Exo::Color.new options }

      it{ should be_a_color(255, 0, 0, 255) }
    end
  end

  context "created with no option" do
    subject { Exo::Color.new }

    it{ should be_a_color(0, 0, 0, 255) }
  end

  context 'created with 0xffff0000' do
    let(:color) { Exo::Color.new hex_argb: 0xffff0000 }

    all_options.each do |options|
      options.keys.each do |key|
        describe "##{key}" do
          subject { color.send(key) }

          it{ should eq options[key] }
        end
      end
    end

    describe '#+' do
      let(:color2) { Exo::Color.new hex_argb: 0xff00ff00 }
      subject { color + color2 }

      it{ should be_a_color(255, 255, 0, 255) }
    end

    describe '#-' do
      let(:color2) { Exo::Color.new hex_argb: 0x88880088 }
      subject { color - color2 }

      it{ should be_a_color(119, 0, 0, 119) }
    end

    describe '#==' do
      subject { color == color2 }

      context 'with an equivalent color' do
        let(:color2) { Exo::Color.new hex_argb: 0xffff0000 }

        it { should be_true }
      end

      context 'with a different color' do
        let(:color2) { Exo::Color.new hex_argb: 0xffffff00 }

        it { should be_false }
      end
    end

  end

end

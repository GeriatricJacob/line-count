module Exo
  class Color
    attr_accessor :red, :green, :blue, :alpha

    def initialize(options={})

      format_found = false

      %w(rgb rgba hex hex_argb html html_argb css_rgb css_rgba pixel).each do |k|
        k = k.to_sym
        if options[k] and not format_found
          send("#{k}=", options[k])
          format_found = true
        end

      end

      unless format_found
        self.red = options[:red] || 0
        self.green = options[:green] || 0
        self.blue = options[:blue] || 0
        self.alpha = options[:alpha] || 255

      end
    end

    # Color Formats Accessors

    def rgb; [red, green, blue]; end
    def rgb=(rgb)
      self.rgba = rgb + [255]
    end

    def rgba; [red, green, blue, alpha]; end
    def rgba=(rgba)
       self.red, self.green, self.blue, self.alpha = rgba
    end

    def hex; (red << 16) + (green << 8) + blue; end
    def hex=(hex)
      self.hex_argb = 0xff000000 + hex
    end

    def hex_argb; (alpha << 24) + (red << 16) + (green << 8) + blue; end
    def hex_argb=(hex_argb)
        self.alpha = hex_argb >> 24 & 0xff
        self.red = hex_argb >> 16 & 0xff
        self.green = hex_argb >> 8 & 0xff
        self.blue = hex_argb & 0xff
    end

    def html; "##{self.hex.to_s(16).rjust(6, '0')}"; end
    def html=(html)
      self.html_argb = html.gsub('#', '#ff')
    end

    def html_argb; "##{self.hex_argb.to_s(16).rjust(8, '0')}"; end
    def html_argb=(html_argb)
      html_argb = html_argb.gsub('#', '')
      self.hex_argb = html_argb.to_i(16)
    end

    def css_rgb; "rgb(#{red},#{green},#{blue})"; end
    def css_rgb=(css_rgb)
      self.css_rgba = css_rgb.gsub('rgb', 'rgba').gsub(')', ',1)')
    end

    def css_rgba; "rgba(#{red},#{green},#{blue},#{alpha / 255})"; end
    def css_rgba=(css_rgba)
      match = /
        rgba
        \(
          \s*(?<red>\d+)\s*,
          \s*(?<green>\d+)\s*,
          \s*(?<blue>\d+)\s*,
          \s*(?<alpha>\d+)\s*
        \)
      /x.match css_rgba

      self.red = match[:red].to_i
      self.green = match[:green].to_i
      self.blue = match[:blue].to_i
      self.alpha = (match[:alpha].to_f * 255).to_i
    end

    def pixel
      r = red / 255.0 * Magick::QuantumRange
      g = green / 255.0 * Magick::QuantumRange
      b = blue / 255.0 * Magick::QuantumRange
      a = (255.0 - alpha) / 255.0 * Magick::QuantumRange
      Magick::Pixel.new r, g, b, a
    end
    def pixel=(pixel)
      self.red = pixel.red / Magick::QuantumRange * 255
      self.green = pixel.green / Magick::QuantumRange * 255
      self.blue = pixel.blue / Magick::QuantumRange * 255
      self.alpha = (Magick::QuantumRange - pixel.opacity) / Magick::QuantumRange * 255
    end

    # Methods

    def interpolate(color, amount, preserve_alpha=false)
      amount = 0.0 if amount.nan?
      reverse_amount = 1.0 - amount

      Exo::Color.new({
        red: (red * reverse_amount + color.red * amount).floor,
        green: (green * reverse_amount + color.green * amount).floor,
        blue: (blue * reverse_amount + color.blue * amount).floor,
        alpha: preserve_alpha ? alpha : (alpha * reverse_amount + color.alpha * amount).floor
      })
    end

    # Operators

    def +(color)
      Exo::Color.new({
        red: [red + color.red, 255].min,
        green: [green + color.green, 255].min,
        blue: [blue + color.blue, 255].min,
        alpha: [alpha + color.alpha, 255].min,
      })
    end

    def -(color)
      Exo::Color.new({
        red: [red - color.red, 0].max,
        green: [green - color.green, 0].max,
        blue: [blue - color.blue, 0].max,
        alpha: [alpha - color.alpha, 0].max,
      })
    end

    def ==(color)
      red == color.red && green == color.green && blue == color.blue && alpha == color.alpha
    end

  end
end

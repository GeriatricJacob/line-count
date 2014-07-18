module Exo
  class Gradient
    attr_accessor :colors, :positions

    def initialize(options={})
      self.colors = options.delete(:colors)
      self.positions = options.delete(:positions)
    end

    def at(position)
      position = sanitize_position(position)

      start_index = start_index_at(position)
      end_index = end_index_at(position)

      start_color = colors[start_index]
      end_color = colors[end_index]

      start_position = positions[start_index]
      end_position = positions[end_index]

      if start_color && !end_color
        start_color
      elsif end_color && !start_color
        end_color
      else
        start_color.interpolate end_color, normalize(position, start_position, end_position)
      end
    end

    def normalize(val, min, max)
      (val.to_f - min.to_f) / (max.to_f - min.to_f)
    end

    def start_index_at(position)
      position = sanitize_position(position)

      self.positions.reverse_each.with_index do |pos, i|
        return self.positions.size - i - 1 if pos <= position
      end

      0
    end

    def end_index_at(position)
      position = sanitize_position(position)

      self.positions.each_with_index do |pos, i|
        return i if pos >= position
      end

      self.positions.size - 1
    end

    def valid_position?(position)
      position >= 0 && position <= 1
    end

    def sanitize_position(position)
      return 0.0 if position < 0
      return 1.0 if position > 1
      position.to_f
    end
  end
end

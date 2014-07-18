class Planet < ActiveRecord::Base
  store_accessor :properties, :elevations

  validates :name, presence: true, uniqueness: true
  validates :seed, presence: true, uniqueness: true

  mount_uploader :surface_image, PlanetSurfaceUploader

  Width = 512
  Height = 256

  def generate_base_map
    start = 32.0
    img_1 = get_perlin_at_scale 1/start
    img_2 = get_perlin_at_scale 1/(start/2.0)
    img_3 = get_perlin_at_scale 1/(start/4.0)
    img_4 = get_perlin_at_scale 1/(start/8.0)

    img = img_1
    [img_2, img_3, img_4].each do |im|
      img = img.composite im, 0, 0, Magick::HardLightCompositeOp
    end

    2.times do
      img = img.contrast(true).contrast(true)
    end

    img = img.blur_image(10)

    img = apply_gradient(img)

    img.write "#{Rails.root}/public/images/0.png"

  end

private

  def generator
    Perlin::Generator.new seed, 2.0, 3
  end

  def get_perlin_at_scale(scale)
    w = Width * scale
    h = Height * scale

    loop_margin_x = (32 * scale).ceil
    loop_margin_y = (32 * scale).ceil

    img = Magick::Image.new w, h
    heights = generator.chunk 0, 0, w + loop_margin_x, h + loop_margin_y, 1

    h.floor.to_i.times do |y|
      w.floor.to_i.times do |x|
        i = 1
        n = normalize_height heights[x][y]

        if x < loop_margin_x
          factor = (loop_margin_x - x) * (loop_margin_x - x)
          n += normalize_height(heights[x + w-1][y]) * factor
          i += factor
        end

        if y < loop_margin_y
          factor = (loop_margin_y - y) * (loop_margin_y - y)
          n += normalize_height(heights[x][y + h-1]) * factor
          i += factor
        end

        n = n / i

        color = Exo::Color.new red: n, green: n, blue: n

        img.pixel_color x, y, color.pixel
      end
    end

    img.resize Width, Height, Magick::CubicFilter
  end

  def normalize_height(height)
    (127 + height * 128).to_i
  end

  def apply_gradient(img)
    5.times do
      img = img.contrast
    end
    img_2 = img

    10.times do
      img_2 = img_2.blur_image(20.0)
    end
    img = img_2.composite(img, 0, 0, Magick::HardLightCompositeOp)
    # img = img.composite(img_2, 0, 0, Magick::HardLightCompositeOp)

    # img = img.threshold Magick::QuantumRange * 0.5
    # return img_2

    polar_size = 50.0

    img.each_pixel do |px, x, y|
      l = px.red / Magick::QuantumRange.to_f
      t = Height / 2.0 - (y - Height / 2.0).abs

      if t < polar_size
        t = (polar_size - t) / polar_size
        l = (l + t).floor == 1.0 ? 1.0 : l
      end

      img.pixel_color x, y, gradient.at(l).pixel
    end

    img
  end

  DeepDeepSea = Exo::Color.new(hex_argb: 0xff20367c)
  DeepSea = Exo::Color.new(hex_argb: 0xff2c4f6d)
  Sea = Exo::Color.new(hex_argb: 0xff00799a)
  SeaShore = Exo::Color.new(hex_argb: 0xff159ac0)
  Grass = Exo::Color.new(hex_argb: 0xff4c721c)
  HighGrass = Exo::Color.new(hex_argb: 0xff679027)
  Desert = Exo::Color.new(hex_argb: 0xffeadf94)
  HighDesert = Exo::Color.new(hex_argb: 0xffe5b472)
  Mountain = Exo::Color.new(hex_argb: 0xff96886d)
  HighMountain = Exo::Color.new(hex_argb: 0xff563b0d)
  Snow = Exo::Color.new(hex_argb: 0xffffffff)

  def gradient
    water_level = 0.63
    transition = 0.08

    @gradient ||= Exo::Gradient.new({
      colors: [
        DeepDeepSea,
        DeepSea,
        Sea,
        SeaShore,
        Grass,
        HighGrass,
        Mountain,
        HighMountain,
        Snow,
        Snow,
      ],
      positions: [
        0,
        water_level * 0.75,
        water_level - transition * 2.0,
        water_level - transition,
        water_level,
        1 - transition * 2.0,
        1 - transition * 2.0 + 0.01,
        1 - transition,
        1 - transition + 0.01,
        1
      ],
    })
  end
end

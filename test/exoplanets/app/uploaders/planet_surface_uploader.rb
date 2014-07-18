# encoding: utf-8

class PlanetSurfaceUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Meta

  process store_meta: [{md5sum: true}]
  version(:icon) { process resize_to_fill: [128, 64] }
  version(:small) { process resize_to_fill: [256, 128] }

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}"
  end

  def default_url
    self.class.processors.each do |name, opts, *other|
      return "http://placehold.it/#{opts.join('x')}/#{(0..2).map{rand(255).to_i.to_s(16)}.join}" if %w(resize_to_fill resize_to_fit).include? name.to_s
    end
    nil
  end
end

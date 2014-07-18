# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Meta

  process store_meta: [{md5sum: true}]
  version(:thumb) { process resize_to_fill: [90, 90] }
  version(:small_thumb) { process resize_to_fill: [50, 50] }

  def store_dir
    "images/#{ model.class.to_s.underscore }/#{ model.id }"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def default_url
    self.class.processors.each do |name, opts, *other|
      return "http://placehold.it/#{opts.join('x')}/#{(0..2).map{rand(255).to_i.to_s(16)}.join}" if %w(resize_to_fill resize_to_fit).include? name.to_s
    end
    nil
  end
end

class User < ActiveRecord::Base
  extend CarrierWave::Meta::ActiveRecord

  paginates_per 1

  rolify

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :email, presence: true

  mount_uploader :avatar, AvatarUploader
  serialize :avatar_meta, OpenStruct
  carrierwave_meta_composed :avatar_meta, :avatar, avatar_version: [:width, :height, :md5sum]

  def to_s
    "#<User: #{name}>"
  end

  def name
    "#{first_name} #{last_name}"
  end
end

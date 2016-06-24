class Pin < ActiveRecord::Base
  validates_presence_of :title, :url, :slug, :text
  #Todo add these fields to the form , :url, :slug, :text, :resource_type
  validates_uniqueness_of :slug

  belongs_to :category
  has_many :pinnings
  has_many :users, through: :pinnings

  has_attached_file :image, styles: { medium: "300x300>", thumb: "60x60>" }, default_url: "http://placebear.com/300/300"
  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
end
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }
  
   has_many :books, dependent: :destroy
   has_many :book_comments, dependent: :destroy
   has_many :favorites, dependent: :destroy
   
 #フォローしている
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  #フォローされてる
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  #フォローしている人(全体)
  has_many :followings, through: :active_relationships, source: :followed
  #フォローされている人（全体）
  has_many :followers, through: :passive_relationships, source: :follower
    has_one_attached :profile_image
    
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  def relationship_by?(user)
    relationship.exists?(user_id: user.id)
  end
end

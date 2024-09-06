class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }
  
   has_many :books, dependent: :destroy
   has_many :group_users   #ここ！
   has_many :groups, through: :group_users
   
   has_many :book_comments, dependent: :destroy
   has_many :favorites, dependent: :destroy
   
   has_many :user_rooms
   has_many :rooms, through: :user_rooms
   has_many :chats
   
   has_many :read_counts, dependent: :destroy
   
  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower
  
  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed
    has_one_attached :profile_image
    
  has_many :notifications, dependent: :destroy
  #9/6通知機能との関連付けの追記
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  def follow(user)
    relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end
  # 6/2 ここからUser検索のモデルを追加 ※変数ではなく空のモデルとして入れるとのこと
    # 更にconsent methodの定義をつける→コントローラで変数として代入する
   def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
      # 6/2 ここまで追加
    end
   end
   # 6/8 ゲストログインのための記述
   GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end
  # 6/8 ゲストログイン記述ここまで
end
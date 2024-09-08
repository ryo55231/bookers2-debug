class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :book
  #9/6通知機能との関連付け追記
  has_one :notification, as: :notifiable, dependent: :destroy 
 #9/6ここまで

  validates :user_id, uniqueness: {scope: :book_id}
end

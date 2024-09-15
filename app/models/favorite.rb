class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :book
  
  #9/6通知機能との関連付け追記
  has_one :notification, as: :notifiable, dependent: :destroy
  #9/6ここまで

  #9/9通知機能　コールバックのための記述
  after_create do
    create_notification(user_id: book.user_id)
  end
  #9/9ここまで
  
  validates :user_id, uniqueness: {scope: :book_id}
end

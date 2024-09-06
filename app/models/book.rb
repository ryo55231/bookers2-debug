class Book < ApplicationRecord
  belongs_to :user
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
    has_many :book_comments, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :week_favorites, -> { where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: 'Favorite'
    has_many :read_counts, dependent: :destroy
    
    has_many :notifications, as: :notifiable, dependent: :destroy 
    #9/6 通知機能を関連付ける追記
    
    validates :tag,presence:true
  
  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end
  #8/20投稿数の前日比 / 先週比を表示するための記述
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  #8/21chart.jsを使って過去7日分の投稿数をグラフ化するための記述
   scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
   scope :created_2day_ago, -> { where(created_at: 2.day.ago.all_day) }
   scope :created_3day_ago, -> { where(created_at: 3.day.ago.all_day) }
   scope :created_4day_ago, -> { where(created_at: 4.day.ago.all_day) }
   scope :created_5day_ago, -> { where(created_at: 5.day.ago.all_day) }
   scope :created_6day_ago, -> { where(created_at: 6.day.ago.all_day) }
  #8/21ここまで
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }
    #8/20ここまで
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
   # 6/2 ここからBook検索のモデルを追加 ※変数ではなく空のモデルとして入れるとのこと
    # 更にconsent methodの定義をつける→コントローラで変数として
  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
         # 6/2 ここまで
    end
  end
end


class Book < ApplicationRecord
  belongs_to :user
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
    has_many :book_comments, dependent: :destroy
    has_many :favorites, dependent: :destroy
  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end
  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :star_count, -> {order(star: :desc)}
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
   # 6/2 ここからBook検索のモデルを追加 ※変数ではなく空のモデルとして入れるとのこと
    # 更にconsent methodの定義をつける→コントローラで変数として代入する
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


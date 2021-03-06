class SearchInfo < ApplicationRecord
  belongs_to :user
  has_many :ranks

  # 登録されているキーワード、商品URLから。ランキングを取得
  def check_ranking
    item_top30_url_array = RakutenWebService::Ichiba::Item.search(keyword: keyword).map { |n| n["itemUrl"] }
    item_top30_url_array.index { |s| s =~ /#{url}/ } || "30位以下または商品URLが間違っています。"
  end
end

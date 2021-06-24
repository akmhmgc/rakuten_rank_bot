class SearchInfo < ApplicationRecord
  belongs_to :user

  # 登録されているキーワード、商品URLから。ランキングを取得
  def ranking
    item_top30_url_array = RakutenWebService::Ichiba::Item.search(keyword: keyword).map { |n| n["itemUrl"] }
    item_top30_url_array.index { |s| s =~ /#{url}/ }
  end
end

class User < ApplicationRecord
  has_one :search_info

  #   キーワードとURLを登録または更新する
  def add_keyword_and_product_url(keyword, url)
    # キーワード・URLを変更する際は保存していたランキングをリセット
    if search_info
      search_info.ranks.destroy_all
      search_info.update(keyword: keyword, url: url)
    else
      create_search_info(keyword: keyword, url: url)
    end
  end
end

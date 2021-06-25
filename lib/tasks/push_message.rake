namespace :push_line do
  desc "LINEBOT：現在の順位の通知"
  task push_line_message_rank: :environment do
    client = Line::Bot::Client.new do |config|
      config.channel_secret = Rails.application.credentials.line_channel[:secret]
      config.channel_token = Rails.application.credentials.line_channel[:token]
    end
    User.all.each do |user|
      search_info = user.search_info
      next unless search_info

      rank_order = search_info.check_ranking

      #  ランキングを保存（一日あたり一回分しか保存されない）
      search_info.ranks.find_or_create_by!(updated_at: Time.zone.today.all_day) do |rank|
        rank.rank = rank_order
      end
      message = {
        type: 'text',
        text: "キーワード:#{search_info.keyword}\n商品URL:#{search_info.url}\n本日の順位:#{rank_order}"
      }
      client.push_message(user.uid, message)
    end
  end
end

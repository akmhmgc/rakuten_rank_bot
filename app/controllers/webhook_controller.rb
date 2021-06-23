class WebhookController < ApplicationController
  def callback
    body = request.body.read
    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          user_id = event['source']['userId']
          message_sent_by_user = event.message['text']
          case message_sent_by_user
          when "登録情報"
            user = User.find_by(uid: user_id)
            reply_text = if user.search_info
                           "現在の登録内容は\nキーワード:#{user.search_info[:keyword]}\nURL:#{user.search_info[:url]}"
                         else
                           "登録\nキーワード\n商品URL\nを登録してください"
                         end
          when "ランキング"
            reply_text = "ランキング"
          when %r{登録\n(\S+)\n(https://item.rakuten.co.jp/.+[^/])}
            keyword = Regexp.last_match(1)
            url = Regexp.last_match(2)
            user = User.find_by(uid: user_id)
            user.add_keyword_and_product_url(keyword, url)
            reply_text = "以下の内容で登録が完了しました。\nキーワード:#{keyword}\nURL:#{url}"
          end
          reply_when_not_matched = "現在のランキングを知りたい場合は「ランキング」\n、登録情報を確認する場合は「登録情報」と入力してください。"
          #   \nキーワードと商品URLを登録する場合は、\n登録\nキーワード\n商品URL\nと入力してください。
          message = {
            type: 'text',
            text: reply_text || reply_when_not_matched
          }
          client.reply_message(event['replyToken'], message)

        when Line::Bot::Event::MessageType::Follow
          user_id = event['source']['userId']
          User.find_or_create_by(uid: user_id)
        when Line::Bot::Event::MessageType::Unfollow
          user_id = event['source']['userId']
          user = User.find_by(uid: user_id)
          user.destroy if user.present?
        end
      end
    end
    head :ok
  end
end

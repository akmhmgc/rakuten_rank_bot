require 'line/bot'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :validate_signature

  def validate_signature
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    error 400 do 'Bad Request' end unless client.validate_signature(body, signature)
  end

  def client
    @client ||= Line::Bot::Client.new do |config|
      # ローカルで動かすだけならベタ打ちでもOK
      config.channel_secret = "90d4fabc641260d27ae30013bc1805b5"
      config.channel_token = "9Dxgw7jMRP04dSEpiaL9JZt3Cpsu51s/Tj+RfmAjxvemDl59mWkBeOHOvRfa130qF7TgQhJvsgoPN2GZ013akExxA0zQhuP+4ROB5Dpoi82amazb5eWO9fF0ZzpJJCNDKZZC6WWHWD/pYh0mk4nugQdB04t89/1O/w1cDnyilFU="
    end
  end
end

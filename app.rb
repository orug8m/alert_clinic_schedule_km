# frozen_string_literal: true

require_relative 'lib/logging'
require_relative 'lib/reservation_checker'
require_relative 'lib/slack_configure'

require 'net/http'
require 'nokogiri'
require 'json'

def execute
  logger = Logging.create
  login_user = ENV.fetch('WEB_USERNAME', nil)
  logger.info("病院の予約チェックを開始: ")

  is_available = ReservationChecker.new.call

  notifi_slack(msg: "こまクリニック: 本日の予定に空き時間があります.") if is_available

  {
    statusCode: 200,
    body: {
      message: 'complete'
    }.to_json
  }
rescue StandardError => e
  logger.error("処理を中止しました. #{e}")
  {
    statusCode: 400,
    body: {
      message: e.message,
      backtrace: e.backtrace.join("\n")
    }.to_json
  }
end

# @param mached_dates [Array<Str>] MM-DDの配列
def notifi_slack(msg:)
  client = Slack::Web::Client.new
  client.chat_postMessage(
    channel: '#小児科_予約可能_通知',
    text: msg,
    as_user: true
  )
end

execute

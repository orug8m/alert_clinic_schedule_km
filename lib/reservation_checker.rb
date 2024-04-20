# frozen_string_literal: true

require_relative 'logging'
require 'uri'

# チェッカー
class ReservationChecker
  def initialize
    @logging = Logging.create
  end

  # @return [boolean] 予約が空いていればtrue
  def call
    puts('予約状況を確認します。')

    url = URI.parse(ENV.fetch('CLIENT_URL', ''))

    raise StandardError, 'URLが設定されていません.' if url.to_s.empty?

    response = Net::HTTP.get_response(url)

    if response.code == '200'
      is_available = res_200_process!(response:)
    else
      @logging.error("HTTPレスポンスエラー: #{response.code}")
      raise StandardError, e
    end

    puts('予約状況の確認が完了しました。')
    return is_available
  end

  private

  # @return [boolean] 予約が空いていればtrue
  def res_200_process!(response:)
    html = Nokogiri::HTML(response.body)
    element = html.at_css('#waita-box-first')

    if element
      sub_elem = element.at_css('.box__content .group-box--caution')
      msg = sub_elem.text
      @logging.info(msg)

      if msg.include?('只今の時間は')
        @logging.info('時間外' )
        return false
      end

      return msg.include?('予約枠がうま') ? false : true
    end

    @logging.info('検索したい内容と一致する要素が見つかりませんでした.')
    raise StandardError, '検索したい内容と一致する要素が見つかりませんでした.'
  end
end

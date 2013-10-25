class Item < ActiveRecord::Base
  def self.getRakutenItems(locate='')
    rakuten_items = [];
    begin
      return rauten_items if locate.blank?
      httpClient = HTTPClient.new
      data = httpClient.get_content('https://app.rakuten.co.jp/services/api/IchibaItem/Search/20130805', {
        'applicationId' =>'1040308007638376273',
        'affiliateId'   =>'11b678a4.eca51fe8.11b678a5.89b6a8b9',
        'keyword'       => self.cutLocate(locate) << '　土産',
        'hits'          => 20,
        'page'          => 1
      })
      jsonData = JSON.parse data
      jsonData['Items'].each do | itemData |
        item = itemData['Item']
        rakuten_items << item
        # p "#{item['itemName']} #{item['itemPrice']}円"
      end
    rescue HTTPClient::BadResponseError => e
      p e.res.code # Error Code
      p e.res.body # Body
    rescue HTTPClient::TimeoutError => e
      p "Timeout Error"
    ensure
      return rakuten_items
    end
  end

  private
  # 北海道以外は末尾の都府県を取り除く
  def self.cutLocate(locate)
    locate.gsub(/(都|府|県)$/u, "")
  end
end

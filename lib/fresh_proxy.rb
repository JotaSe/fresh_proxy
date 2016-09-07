require 'fresh_proxy/version'

# Class to scrap proxies from incloak
class FreshProxy
  def initialize
    @agent = Mechanize.new
  end

  # scrap incloak page for the proxies with maxtime = 1000ms
  def extract_page
    @agent.get 'https://incloak.com/proxy-list/?maxtime=1000&type=hs#list'
  end

  # get the most fresh proxy
  def fresh
    page = extract_page
    {
      ip: page.search('.//table//tbody//tr[1]//td[1]').text,
      port: page.search('.//table//tbody//tr[1]//td[2]').text,
      speed: page.search('.//table//tbody//tr[1]//td[4]').text
    }
  end

  # get the last 64 most fresh proxies
  def extract_proxies
    extract_page.search('.//table//tbody//tr').map do |row|
      {
        ip: row.search('.//td[1]').text,
        port: row.search('.//td[2]').text,
        speed: row.search('.//td[4]').text
      }
    end
  end
end

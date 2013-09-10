require 'net/http'

class Page < ActiveRecord::Base
  attr_accessible :title, :host, :path, :count, :difference

  validates_presence_of :path

  def Page.populate
    uri = URI('http://api.chartbeat.com/live/toppages/')
    pages = []
    #Usually I'd hide the below key
    key = '317a25eccba186e0f6b558f45214c0e7'

    ["gizmodo.com", "avc.com", "someecards.com"].each do |host|
      uri.query = URI.encode_www_form(:apikey => key,
                                      :host => host,
                                      :limit => 100
                                      )
      response = Net::HTTP.get_response(uri)
      pages_attrs = JSON.parse(response.body, symbolize_names: true)

      pages_attrs.each do |page|
        old_page = Page.find_by_host_and_path(host, page[:path])
        old_count = old_page ? old_page.count : 0

        new_page = old_page || Page.new(title: page[:i],
                  host: host,
                  path: page[:path]
                  )
        new_page.count = page[:visitors]
        new_page.difference = new_page.count - old_count
        pages << new_page
      end
    end

    #So slow!
    ActiveRecord::Base.transaction do
      pages.each {|page| page.save}
    end

    #The below only works if we're only adding rows, not updating.
    #Page.import pages
  end
end

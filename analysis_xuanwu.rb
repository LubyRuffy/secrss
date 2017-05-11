#/usr/bin/env ruby
# encoding: utf-8
require 'nokogiri'
require 'domainatrix'

class XuanwuRss
  def initialize
    @dir = File.join(File.dirname(__FILE__), 'XuanwuLab.github.io')
  end

  def run
    objs = []
    git_update
    files = File.join(@dir, "cn", "secnews", "**", "*.html")
    Dir.glob(files){|file|
      objs += analysis_file(file) {|obj|
        yield(obj) if block_given?
      }
    }
    objs
  end

  def git_update
    unless Dir.exists?(@dir)
      puts `git clone https://github.com/XuanwuLab/XuanwuLab.github.io.git`
    end

    puts `cd XuanwuLab.github.io; git pull`
  end

  def analysis_file(file)
    objs = []
    doc = Nokogiri.parse(File.read(file).force_encoding('utf-8'))
    doc.xpath('//*[@id="weibowrapper"]/ul').each{|ul|
      objs += parse_content(ul) {|obj|
        yield(obj) if block_given?
      }
    }
    objs
  end

  def parse_content(ul)
    objs = []
    if ul['class'] == 'weibolist'
      ul.xpath('li/div[@id="singleweibo"]').each{|content|
        #source = content.at_xpath('*[@id="singleweiboheader"]/*[@id="singleweibologo"]/img')['src']
        author = content.at_xpath('*[@id="singleweiboheader"]/*[@id="singleweiboauthor"]/p').text
        body = content.at_xpath('*[@id="singleweibobody"]/*[@class="singleweibotext"]/p').inner_html
        fullname,atname = author.split('@', 2)
        tag, link, description = parse_body(body)

        obj = {source:'twitter', fullname:fullname.strip, atname: atname.strip, tag: tag.strip, link: link.strip, description: description.strip}
        objs << obj
        yield(obj) if block_given?

      }
    elsif ul['id'] == 'manualfeedlist'
      ul.xpath('li/div[@class="singlemanualfeed"]').each{|content|
        author = content.at_xpath('*[@class="singlefeedheader"]/*[@class="singlefeedauthor"]/p').text
        fullname,atname = author.split('via', 2)
        body = content.at_xpath('*[@class="singlefeedbody"]/*[@class="singlefeedtext"]/p').inner_html
        tag, link, description = parse_body(body)

        obj = {source:fullname.strip, atname: atname.strip, tag: tag.strip, link: link.strip, description: description.strip}
        objs << obj
        yield(obj) if block_given?
      }
    else
      throw "unknown ul of #{ul.html}"
    end
    objs
  end

  def parse_body(body)
    tag = ''
    link = ''
    m = body.match(/[\[]?(?<tag>.*?)\](?<description>.*?)\<a href="(?<link>.*?)"/um)

    unless m
      m = body.match(/[\[]?(?<tag>.*?)\](?<description>.*)(?<link>http[s]?:\/\/.*?)/um)
    end

    unless m
      m = body.match(/[\[]?(?<tag>.*?)\](?<description>.*)/um)
    end

    if m
      tag = m[:tag].scan(/\<i\>(.*?)\<\/i\>/um).first.first.strip
      link = m[:link].strip if m.names.include? 'link'
    end

    [tag, link, m[:description]]
  end

  def self.host_of_url(url)
    begin
      url = 'http://'+url+'/' if !url.include?('http://') and !url.include?('https://')
      url = URI.encode(url) unless url.include? '%' #如果包含百分号%，说明已经编码过了
      uri = URI(url)
      uri.host
    rescue => e
      nil
    end
  end
end


objs = XuanwuRss.new.run{|obj|
  print '.'
}
cnt_hash = objs.each_with_object(Hash.new(0)){|h1, h2| h2[h1[:atname]]+=1}.sort_by{|k,v| v}.reverse
puts ""
puts "distinct count: #{cnt_hash.size}"
all_cnt = 0
cnt_hash.each{|k,v|all_cnt+=v}
puts "articles count: #{all_cnt}"
puts "sort by source: "
puts cnt_hash.map{|k,v| "#{k}:\t#{v}"}

tag_hash = objs.each_with_object(Hash.new(0)){|h1, h2| h2[h1[:tag]]+=1}.sort_by{|k,v| v}.reverse
puts "distinct tag count: #{tag_hash.size}"
puts "sort by tag: "
puts tag_hash.map{|k,v| "#{k}:\t#{v}"}

host_hash = objs.each_with_object(Hash.new(0)){|h1, h2| h2[XuanwuRss.host_of_url(h1[:link])]+=1}.sort_by{|k,v| v}.reverse
puts "distinct host count: #{host_hash.size}"
puts "sort by host: "
puts host_hash.map{|k,v| "#{k}:\t#{v}"}
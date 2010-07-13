class PagesController < ApplicationController
  def home
    require 'open-uri'
    require 'nokogiri'


    url = 'http://www.pokernews.com/live-reporting/2010-wsop/main-event/chips.htm'
    doc = Nokogiri::HTML.parse(open(url))

    @categories = %w[Level Blinds Ante Remaining_Players Total_Entries]
    @info = []
    doc.xpath('//dd//dd').each do |data|
      @info << data.inner_text.to_s
    end

    data_array = []
    doc.xpath('//*[(@id = "chipsCountEntries")]//*[contains(concat( " ", @class, " " ), concat( " ", "numeric", " " )) and (((count(preceding-sibling::*) + 1) = 3) and parent::*)] | //*[(@id = "chipsCountEntries")]//td[(((count(preceding-sibling::*) + 1) = 1) and parent::*)]').each do |data|
      data_array << data.inner_text.strip
    end

    len = data_array.length
    player_count = 0
    @player = []
    @chips = []

    (0..len).step(2) do |x|
      @player[player_count] = data_array[x]
      @chips[player_count] = data_array[x+1]
      player_count +=1
    end

    jeff = @player.index("Jeff Heiberg")
    begin
      @note = "#{jeff+1} -- Jeff Heiberg -- #{chips[jeff]}"
    rescue
      @note = "Jeff's chipcount not listed...stay tuned!"
    end   
  end
end

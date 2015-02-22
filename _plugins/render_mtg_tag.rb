module Jekyll
  class RenderMtgTag < Liquid::Block
    include Liquid::StandardFilters
  
    def initialize(tag_name, markup, tokens)
      super

      @meta = markup && markup.length >= 2 ? JSON.parse(markup) : nil
    end
  
    def render(context)
	    @array = super.split(/\r?\n/)
    
      @content = ""


      @array.each do |line|

        #do a match against qty - /[0-9]{1,3}x/
        @content += "<span>"
        if m = line.match(/[0-9]{1,3}x/)

          @content += m[0]
          @content += " <a href='https://deckbox.org/mtg/#{m.post_match.lstrip}'>#{m.post_match.lstrip}</a>"

        else
          @content += "<a href='https://deckbox.org/mtg/#{line.lstrip}'>#{line.lstrip}</a>"
        end
        @content += "</span>"
      end

      if @array.length > 1
        meta = ""

        unless @meta.nil?
          unless @meta["title"].nil?
            meta += "<div>"
            meta += "<h3>"+ @meta["title"] + "</h3>"

            unless @meta["commander"].nil?
              meta += "<h4> Commander: "+ "<a href='https://deckbox.org/mtg/#{@meta["commander"]}'>#{@meta["commander"]}</a>" + "</h4>"
            end
            meta += "</div>"
          end
        end

        @content = "<div class='well mtg-list'>"+ meta + @content + "</div>"
      end

      return @content
    end
  
  end
end

Liquid::Template.register_tag('render_mtg', Jekyll::RenderMtgTag)

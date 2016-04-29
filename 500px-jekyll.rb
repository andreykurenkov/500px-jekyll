require 'yaml'
require 'jekyll'
require 'f00px'
require "json"
# Usage:
#   
#	{% 500px accesstokenpath:C:\500px-access-token.txt %}
#		<div>
#			<h3>{{ item.name }}</h3>
#			<img src="{{ item.images.large.url }}" />
#		</div>
#	{% end500px %}
#
# Parameters:
#   accesstokenpath: the path to a text file containing a consumer key+secret for 500PX on two lines

class PXLoader
	class << self
		def photos(authpath)
			lines = File.open(authpath).read.lines
            consumer_key = lines.next
            consumer_secret = lines.next
			F00px.configure do |config|
			  config.consumer_key = consumer_key.strip()
			  config.consumer_secret = consumer_secret.strip()
			end
           F00px.user_photos(8390703, { "image_size" => [3,4], "rpp" => 100})
		end
	end
end


module Jekyll
  class PXTag < Liquid::Block

    include Liquid::StandardFilters
    Syntax = /(#{Liquid::QuotedFragment}+)?/ 

    def initialize(tag_name, markup, tokens)
      @variable_name = 'item'
      @attributes = {}
      
      # Parse parameters
      if markup =~ Syntax
        markup.scan(Liquid::TagAttributes) do |key, value|
          @attributes[key] = value
        end
      else
        raise SyntaxError.new("Syntax Error in 'delicious' - Valid syntax: 500px authpath:x]")
      end

      @authpath = @attributes['authpath']
      @name = 'item'

      super
    end

    def render(context)
	  response = PXLoader.photos(@authpath)
      data = JSON.parse(response.body)
      photos = data["photos"]
      result = []
      context.stack do
        photos.each_with_index do |item, index|
          images = item["images"]
          item["images"] = {'thumbnail' => images.first, 'large' => images.last}
          context[@variable_name] = item
          context['forloop'] = {
            'name' => @name,
            'length' => photos.count,
            'index' => index + 1,
            'index0' => index,
            'rindex' => photos.count - index,
            'rindex0' => photos.count - index -1,
            'first' => (index == 0),
            'last' => (index == photos.count - 1) }
          result << render_all(@nodelist, context)
        end
      end     
      result
    end
  end
end

Liquid::Template.register_tag('500px', Jekyll::PXTag)

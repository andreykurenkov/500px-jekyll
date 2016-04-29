A plugin to add 500px galleries to your Jekyll site inspired by and very similar to [instagram-jekyll](https://github.com/mthomas/instagram-jekyll).

I wanted to have photos from both 500px and instagram displayed nicely on my site, and so created this to be extremely similar in usage and output. 
Example of using both at [my site](http://www.andreykurenkov.com/photography/). 

To get the consumer key and secret [apply to make a 500px application](https://500px.com/settings/applications)

# Example usage:
#   
#	<div class="popup-gallery" id="500px_gallery">
#		{% 500px authpath:/home/andreyk/Desktop/pxtoken.txt %}
#			<a href="{{ item.images.large.url }}" 
#               title="{{ item.name }}">
#               <img src="{{ item.images.thumbnail.url }}" width="24.5%"></a>
#		{% end500px %}
#	</div>
# Parameters:
#   accesstokenpath: the path to a text file containing a consumer key+secret for 500PX on two lines


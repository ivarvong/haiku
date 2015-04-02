require 'tempfile'
require 'mini_magick'

class SocialImage

	def build(text: '')
		base_path = File.expand_path(File.join(File.dirname(__FILE__), 'social_background.png'))
		
		tempfile = Tempfile.new('h')

		image = MiniMagick::Image.open(base_path)
		
		image.combine_options do |c| 
			c.gravity 'Center' #'SouthWest'
			c.antialias 

			c.font "helveticaneue.ttf"
			#c.weight "500"
			c.fill "#fff"
			c.pointsize "80"
			#c.interline_spacing settings[:main_spacing]
			#c.kerning           settings[:main_kerning]
			c.draw "text 0,0 \"#{text.join("\n").gsub('"', "\\\"")}\""
		end

		image.write(tempfile.path)
	
		return tempfile.path
	end
end
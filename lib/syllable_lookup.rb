require 'json'

class SyllableLookup

	def initialize	
		@lookup_cache_path = expand_path('cmudict-lookup.json')
		@lookup = {}

		if File.exists? @lookup_cache_path
			@lookup = JSON.parse File.open(@lookup_cache_path).read
		else
			build()
			dump_json()
		end
	end

	def lookup(word)
		cleaned = word.upcase.gsub(/[^a-zA-Z]/, '') # TODO: is this safe?
		@lookup[cleaned]
	end

	def expand_path(path)
		File.expand_path(File.join(File.dirname(__FILE__), path))
	end

	def build
		File.open(expand_path("cmudict.txt"))
			.readlines
			.each do |line|
				# word is upcase in cmudict
				word, *pronouce = line.split(' ')
				syllable_count = pronouce.join(' ').scan(/[0-9]/).count
				@lookup[word] = syllable_count
			end
	end

	def dump_json
		File.open(@lookup_cache_path, 'w') do |f|
			f.write JSON.pretty_generate @lookup
		end
	end

end
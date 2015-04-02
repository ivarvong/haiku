require_relative 'syllable_lookup'

class Haiku

	def initialize(text: nil)
		@corpus = []
		@syllable_lookup = SyllableLookup.new
	end

	def words_with_syls
		@words_with_syls ||= begin 
			@corpus.map do |word|	
				[word, @syllable_lookup.lookup(word)]
			end
		end
	end

	def syl_count(word_list)
		word_list.reduce(0) do |total, (word, count)|
			total + count
		end
	end

	def is_total_syl?(list)
		syl_count(list) == 17 # haikus have a total of 17 syllables
	end

	def find_partition(list)
		# TODO: this is ugly.

		(1..(list.length-2)).each do |first_offset|
			(first_offset..list.length).each do |second_offset|
						
				line1 = list.slice(0, first_offset)
				line2 = list.slice(first_offset, second_offset-first_offset)
				line3 = list.slice(second_offset, list.length)

				if syl_count(line1) == 5 and syl_count(line2) == 7 and syl_count(line3) == 5
					return [line1, line2, line3] 
				end

			end
		end

		nil
	end

	def search_after_offset(offset)
		search_within_subset(
			words_with_syls().slice(offset, 17)
		)
	end

	def search_within_subset(word_list)
		return nil if word_list.select{|(word, count)| count.nil? }.length > 0

		(3..17).map do |subset_length|
			subset = word_list.slice(0, subset_length)
			find_partition(subset) if is_total_syl?(subset) 			
		end.compact
	end

	def search(text: "")
		@corpus = text.split(' ')
		
		matches = (0..words_with_syls().length).flat_map do |offset|
			search_after_offset(offset)
		end.compact

		matches.map do |match|
			match.map do |line|
				line.map do |word|
					word.first
				end.join(' ')
			end
		end
	end

end
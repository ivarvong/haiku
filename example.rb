text = <<END
On the evening of Aug. 9, 2011, one month before the 40th anniversary of the bloody Attica prison riot, a guard in that remote facility in western New York was distributing mail to inmates in C Block, one of the vast tiers of cells nestled behind its towering 30-foot walls.

The prisoners were rowdy that night, talking loudly as they mingled on the gallery outside their cells, a State Police inquiry found. Frustrated, an officer shouted into the din: “Shut the (expletive) up.”

Normally, that would be enough to bring quiet to C Block, where guards who work the 3 to 11 p.m. shift are known for strict, sometimes violent, enforcement of the rules. This night, somewhere on the gallery, a prisoner shouted back, bellowing “You shut the (expletive) up.” Emboldened, the shouter taunted the officer with an obscene suggestion.
END

require './lib/haiku'

haiku = Haiku.new(text: text)

haiku.search.each do |match|
	puts match.join("\n")
	puts " "
end
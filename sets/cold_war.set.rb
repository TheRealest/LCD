require_relative '../src/set_dsl'

# debug :library
level :blue
	category :gender
		trait :male
		trait :female
		trait :mechanical
	category :age
		trait :teen
		trait :adult
		trait :old
level :purple
	category :nationality
		trait :eastern_bloc
		trait :western_bloc
		trait :non_aligned
	category :religion
		trait :atheism
		trait :christianity
		trait :islam
level :green
	category :occupation
		trait :activist
		trait :medic
		trait :police
		trait :politician
		trait :scientist
		trait :soldier
		trait :spy
	category :organization
		trait :gehlen_org # US intelligence agency in Germany
		trait :safari_club # Alliance of intelligence services of non-aligned countries (Iran, Egypt, Saudi Arabia, Morocco, France)
		trait :teapot_committee # American think tank studying strategic missles
		trait :NKVD # Russian secret police
		trait :spetsnaz # Russian special forces
	category :personality
		trait :ruthless
		trait :merciful
		trait :genius
		trait :cunning
		trait :lawful
		trait :leader
level :black
	# ???

# debug :generator
pattern :blue, :blue, name: :basic, weight: :never
pattern :basic, :purple, name: :one_purple, weight: :rarely
pattern :basic, :purple, :purple, name: :two_purple
pattern :one_purple, :green
pattern :one_purple, :green, :green
pattern :two_purple, :green
pattern :basic, :nationality, :personality
pattern :basic, :occupation, :organization

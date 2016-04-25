class HomeController < ApplicationController

require 'net/http'
require 'json'
require 'unirest'
require 'rubygems'
require 'engtagger'
require 'nokogiri'
require 'open-uri'
require 'ruby_rhymes'


#To Do:
#1. Build If-Else Statements into methods to check syllables
#2. Update verb tenses in gangsta party
#3. Gem has difficulty when passed a past tense verb

def getNouns(strung_array)
#Takes a string as a parameter. Returns an array of all nouns in that string

	tgr = EngTagger.new
	tagged = tgr.add_tags(strung_array)

	#Get nouns based on part of speech tag. Returns as a hash
  	@respnouns = tgr.get_nouns(tagged)
  	@result = []
  	#Isolate keys from tags

  	#Tests if original string or returned hash is empty
  	if @respnouns.nil?
  		return FillNil(@result)
  	# elsif @respadj.empty?
  	# 	return FillNil(@result)
  	else
  		@respnouns.each_key do |key|
  		@result.push(key)
  		end

  	return @result
  	end
	
end

def getRhymes(word)
	@word = word
	@result = []
	@rhymes = Unirest.get "http://rhymebrain.com/talk?function=getRhymes&word=#{@word}", headers:{
   		"Accept" => "application/json"
  	}

  	@rhymes.body.each do |x|
  		@result.push(x["word"]) if x["score"] >= 240
  	end

  	return @result
end

def getAdj(strung_array)
#getNouns but for adjectives

	tgr = EngTagger.new
	tagged = tgr.add_tags(strung_array)

	#Get nouns based on part of speech tag. Returns as a hash
  	@respadj = tgr.get_adjectives(tagged)

  	#Isolate keys from tags
  	@result = []

	if @respadj.nil?
  		return FillNil(@result)
  	elsif @respadj.empty?
  	 	return FillNil(@result)
  	else
  		@respadj.each_key do |key|
  		@result.push(key)
  	end
  	return @result
  	end
end

def getSpeechPart(strung_array, code)
	#Takes string as argument. Adds speech tags. Searches based on PoS codes. Returns results as an array.
	tgr = EngTagger.new
	@tagged = tgr.add_tags(strung_array)
	@parsedstr = Nokogiri::HTML(@tagged)
	
	@result = @parsedstr.search("//" + code).to_s.gsub('<' + code + '>', '' ).split('</' + code + '>')

	return FillNil(@result)
end

def getVerbs(strung_array)
	tgr = EngTagger.new
	@tagged = tgr.add_tags(strung_array)
	@parsedstr = Nokogiri::HTML(@tagged)

	@result = []
	

	@result.push(@parsedstr.search("//vb").to_s.gsub('<vb>', '' ).split('</vb>')) if @parsedstr.search("//vb").to_s.gsub('<vb>', '' ).split('</vb>').any?

	@result.push(@parsedstr.search("//vbp").to_s.gsub('<vbp>', '' ).split('</vbp>')) if @parsedstr.search("//vbp").to_s.gsub('<vbp>', '' ).split('</vbp>').any?

	# @result.push(@parsedstr.search("//vbd").to_s.gsub('<vbd>', '' ).split('</vbd>')) if @parsedstr.search("//vbd").to_s.gsub('<vbd>', '' ).split('</vbd>').any?
	#Disabled because of conflicts with conjugation gem

	@result.push(@parsedstr.search("//vbg").to_s.gsub('<vbg>', '' ).split('</vbg>')) if @parsedstr.search("//vbg").to_s.gsub('<vbg>', '' ).split('</vbg>').any?

	@result.push(@parsedstr.search("//vbn").to_s.gsub('<vbn>', '' ).split('</vbn>')) if @parsedstr.search("//vbn").to_s.gsub('<vbn>', '' ).split('</vbn>').any?

	@result.push(@parsedstr.search("//vbp").to_s.gsub('<vbp>', '' ).split('</vbp>')) if @parsedstr.search("//vbp").to_s.gsub('<vbp>', '' ).split('</vbp>').any?

	@result.push(@parsedstr.search("//vbz").to_s.gsub('<vbz>', '' ).split('</vbz>')) if @parsedstr.search("//vbz").to_s.gsub('<vbz>', '' ).split('</vbz>').any?

	return FillNil(@result.flatten)

end
def FillNil(array)
	if array[0].nil?
		return array.push("*expletive*")
	else
		return array
	end
end

def RandomInteger(array)
	if array.length == 0
		return 0
	else
		return rand(0..(array.length-1))
	end

end

# def GetSyllables(hash, num)
# 	#Will typically take @response as argument
# 	@result =[]
# 	hash.each do |x|
# 		if (x["syllables"] == num.to_s)
# 			@result.push(x["word"])
# 		end
# 	end
# 	return @result
# end

def SyllableSelect(array, num)
	@result =[]
	array.each do |x|
		@result.push(x) if x.to_phrase.syllables == num
	end
	return @result
end

def index

	@song_list = ["epic","extravagant", "feelin_it", "hippop", "Im_the_king", "mixed_emotion", "newboys","real_rb","so_real","the_beginning","the_one","thee_banger","therealest"]

	@song_title = @song_list[RandomInteger(@song_list)]


	@template_idx = rand(0..3)


	if @template_idx == 0
		@form_path = americkaz_most_prep_path
	elsif @template_idx == 1
		@form_path = good_day_prep_path
	elsif @template_idx == 2
		@form_path = paradise_prep_path
	elsif @template_idx == 3
		@form_path = juicy_prep_path
	elsif @template_idx == 4
		@form_path = lose_yourself_prep_path
	end
		
end


def good_day_prep
	@noun1 = params[:noun1]
	@noun2 = params[:noun2]
	@verb1 = params[:verb1]
	@verb2 = params[:verb2]
	@adj = params[:adj]
	@propNoun = params[:propNoun]

	@noun1rhymes = getRhymes(@noun1)
	@noun2rhymes = getRhymes(@noun2)
	@verb1rhymes = getRhymes(@verb1)
	@verb2rhymes = getRhymes(@verb2)
	@adjrhymes = getRhymes(@adj)

	#About naming convention:
	#First element of instance name relates to param
	#Second relates to instances needed for template
	#n1_n2_idx is the second noun that rhymes with the first parameter

	# @noun1_adj = getAdj(SyllableSelect(@noun1rhymes, @noun1.to_phrase.syllables).join(','))
	# @noun1_adj = getAdj(@noun1rhymes.join(','))
	
	# @n1_adj_idx = RandomInteger(@noun1_adj)
	# @noun1_nouns = getNouns(@noun1rhymes.join(','))

	# @noun1_nouns = getNouns((SyllableSelect(@noun1rhymes,@noun1.to_phrase.syllables)).join(','))

	# @n1_n1_idx = RandomInteger(@noun1_nouns)
	# @n1_n2_idx = RandomInteger(@noun1_nouns)
	# @n1_n3_idx = RandomInteger(@noun1_nouns)

	@noun1_nouns = getNouns((@noun1rhymes).join(','))
	@noun1_adjs = getAdj((@noun1rhymes).join(','))

	@noun1_noun1 = @noun1_nouns[RandomInteger(@noun1_nouns)]
	@noun1_noun2 = @noun1_nouns[RandomInteger(@noun1_nouns)]
	@noun1_noun3 = @noun1_nouns[RandomInteger(@noun1_nouns)]
	@noun1_adj1 = @noun1_adjs[RandomInteger(@noun1_adjs)]

	# @verb1_verbs = getSpeechPart((SyllableSelect(@verb1rhymes, @verb1.to_phrase.syllables)).join(','), "vb")

	# @verb1_verbs = getVerbs(@verb1rhymes.join(','))
	# @v1_v1_idx = RandomInteger(@verb1_verbs)

	@verb1_verbs = getVerbs(@verb1rhymes.join(','))
	@verb1_verb1 = @verb1_verbs[RandomInteger(@verb1_verbs)]

	# @noun2_nouns = getNouns((SyllableSelect(@noun2rhymes,(@noun2.to_phrase.syllables + 2))).join(','))
	# @n2_n1_idx = RandomInteger(@noun2_nouns)

	@noun2_nouns = getNouns(@noun2rhymes.join(','))
	@noun2_noun1 = @noun2_nouns[RandomInteger(@noun2_nouns)]

	# @verb2_nouns = getNouns((SyllableSelect(@verb2rhymes,(@verb2.to_phrase.syllables+1))).join(','))
	# @v2_n1_idx = RandomInteger(@verb2_nouns)

	@verb2_nouns = getNouns(@verb2rhymes.join(','))
	@verb2_noun1 = @verb2_nouns[RandomInteger(@verb2_nouns)]


	# @adj_nouns = getNouns(@adjrhymes.join(','))
	# @adj_adj = getAdj(@adjrhymes.join(','))
	# # @adj_nouns_plus1 = getNouns((SyllableSelect(@adjrhymes,(@adj.to_phrase.syllables+1))).join(','))

	# @adj_adv_plus1 = getSpeechPart(@adjrhymes.map{|x| x + "ly"}.join(','), "rb")
	# #'ly' added to each to increase the liklihood of rhyming with an adverb
	# @adj_n1_idx = RandomInteger(@adj_nouns)
	# @adj_adj_idx = RandomInteger(@adj_adj)
	# @adj_adv_idx = RandomInteger(@adj_adv_plus1)


	@adj_nouns = getNouns(@adjrhymes.join(','))
	@adj_adjs = getAdj(@adjrhymes.join(','))
	@adj_adverbs = getSpeechPart(@adjrhymes.map{|x| x + "ly"}.join(','), "rb")

	@adj_adj1 = @adj_adjs[RandomInteger(@adj_adjs)]
	@adj_adverb1 = @adj_adverbs[RandomInteger(@adj_adverbs)]
	@adj_noun1 = @adj_nouns[RandomInteger(@adj_nouns)]



	redirect_to controller: "home", action: "good_day", noun1: @noun1, noun2: @noun2, verb1: @verb1, verb2: @verb2, adj: @adj, propNoun: @propNoun, noun1_noun1: @noun1_noun1, noun1_noun2: @noun1_noun2, noun1_noun3: @noun1_noun3, noun1_adj1: @noun1_adj1, verb1_verb1: @verb1_verb1, noun2_noun1: @noun2_noun1, verb2_noun1: @verb2_noun1, adj_adj1: @adj_adj1, adj_adverb1: @adj_adverb1, adj_noun1: @adj_noun1
end

def good_day
	@noun1 = params[:noun1]
	@noun2 = params[:noun2]
	@verb1 = params[:verb1]
	@verb2 = params[:verb2]
	@adj = params[:adj]
	@propNoun = params[:propNoun]
	@noun1_noun1 = params[:noun1_noun1]
	@noun1_noun2 = params[:noun1_noun2]
	@noun1_noun3 = params[:noun1_noun3]
	@noun1_adj1 = params[:noun1_adj1]
	@verb1_verb1 = params[:verb1_verb1]
	@noun2_noun1 = params[:noun2_noun1]
	@verb2_noun1 = params[:verb2_noun1]
	@adj_adj1 = params[:adj_adj1]
	@adj_adverb1 = params[:adj_adverb1]
	@adj_noun1 = params[:adj_noun1]

	@sharable_link = request.original_url

end

def gangsta_party_prep
	@noun1 = params[:noun1]
	@noun2 = params[:noun2]
	@verb1 = params[:verb1]
	@verb2 = params[:verb2]
	@adj = params[:adj]
	@propNoun = params[:propNoun]

	# @noun1rhymes = getRhymes(@noun1)
	@noun2rhymes = getRhymes(@noun2)
	@verb1rhymes = getRhymes(@verb1)
	# @verb2rhymes = getRhymes(@verb2)
	@adjrhymes = getRhymes(@adj)

	@propNoun =  @propNoun.upcase.scan(/.{1}/).join("-").insert(-2,"double-").gsub('- -'," ").gsub('-.-',". ").gsub('-. ',". ")

	# @noun2_nouns = getAdj(@noun2rhymes.join(','))
	# @n2_a1_idx = RandomInteger(@noun2_nouns)

	@noun2_adjs = getAdj(@noun2rhymes.join(','))
	@noun2_adj1 = @noun2_adjs[RandomInteger(@noun2_adjs)]

	# @verb1_nouns = getNouns(@verb1rhymes.join(','))
	# @verb1_nouns_plus1 = getNouns((SyllableSelect(@verb1rhymes,(@verb1.to_phrase.syllables + 1))).join(','))
	# @v1_n1_idx = RandomInteger(@verb1_nouns)
	# @v1_n1_p1_idx = RandomInteger(@verb1_nouns_plus1)

	@verb1_nouns = getNouns(@verb1rhymes.join(','))
	@verb1_noun1 = @verb1_nouns[RandomInteger(@verb1_nouns)]
	@verb1_noun2 = @verb1_nouns[RandomInteger(@verb1_nouns)]

	# @adj_nouns = getNouns(@adjrhymes.join(','))
	# @a_n1_idx = RandomInteger(@adj_nouns)

	@adj_nouns = getNouns(@adjrhymes.join(','))
	@adj_verbs = getVerbs(@adjrhymes.join(','))
	@adj_noun1 = @adj_nouns[RandomInteger(@adj_nouns)]
	@adj_verb1 = @adj_verbs[RandomInteger(@adj_verbs)]

	# @adj_verbs_plus1 = getVerbs((SyllableSelect(@adjrhymes,(@adj.to_phrase.syllables+1))).join(','))
	# @adj_v_idx = RandomInteger(@adj_verbs_plus1)

	redirect_to controller: "home", action: "gangsta_party", noun1: @noun1, noun2: @noun2, verb1: @verb1, verb2: @verb2, adj: @adj, propNoun: @propNoun, noun2_adj1: @noun2_adj1, verb1_noun1: @verb1_noun1, verb1_noun2: @verb1_noun2, adj_noun1: @adj_noun1, adj_verb1: @adj_verb1
end


def gangsta_party

	@noun1 = params[:noun1]
	@noun2 = params[:noun2]
	@verb1 = params[:verb1]
	@verb2 = params[:verb2]
	@adj = params[:adj]
	@propNoun = params[:propNoun]
	@noun2_adj1 = params[:noun2_adj1]
	@verb1_noun1 = params[:verb1_noun1]
	@verb1_noun2 = params[:verb1_noun2]
	@adj_noun1 = params[:adj_noun1]
	@adj_verb1 = params[:adj_verb1]

	@sharable_link = request.original_url

end

def gangsta_paradise_prep
	@noun1 = params[:noun1]
	@noun2 = params[:noun2]
	@verb1 = params[:verb1]
	@verb2 = params[:verb2]
	@adj = params[:adj]
	@propNoun = params[:propNoun]

	@noun1rhymes = getRhymes(@noun1)
	@noun2rhymes = getRhymes(@noun2)
	@verb1rhymes = getRhymes(@verb1)
	@verb2rhymes = getRhymes(@verb2)
	@adjrhymes = getRhymes(@adj)

	# @noun1_adj = getAdj(@noun1rhymes.join(','))
	# @n1_adj_idx = RandomInteger(@noun1_adj)

	@noun1_adj = getAdj(@noun1rhymes.join(','))
	@noun1_adj1 = @noun1_adj[RandomInteger(@noun1_adj)]

	# @noun2_verbs = getVerbs(@noun1rhymes.join(','))
	# # @n2_n1_idx = RandomInteger(@noun2_nouns)
	# @n2_v1_idx = RandomInteger(@noun2_verbs)
	# @n2_v2_idx = RandomInteger(@noun2_verbs)

	@noun2_verbs = getVerbs(@noun1rhymes.join(','))
	@noun2_verb1 = @noun2_verbs[RandomInteger(@noun2_verbs)]
	@noun2_verb2 = @noun2_verbs[RandomInteger(@noun2_verbs)]

	# @verb1_verbs = getVerbs(@verb1rhymes.join(','))
	# @v1_v1_idx = RandomInteger(@verb1_verbs)

	@verb1_verbs = getVerbs(@verb1rhymes.join(','))
	@verb1_verb1 = @verb1_verbs[RandomInteger(@verb1_verbs)]


	# @verb2_verbs = getVerbs(@verb2rhymes.join(','))
	# @verb2_nouns = getNouns(@verb2rhymes.join(','))
	# @v2_v1_idx = RandomInteger(@verb2_verbs)
	# @v2_n1_idx = RandomInteger(@verb2_nouns)

	@verb2_verbs = getVerbs(@verb2rhymes.join(','))
	@verb2_nouns = getNouns(@verb2rhymes.join(','))
	@verb2_verb1 = @verb2_verbs[RandomInteger(@verb2_verbs)]
	@verb2_noun1 = @verb2_nouns[RandomInteger(@verb2_nouns)]

	redirect_to controller: "home", action: "gangsta_paradise", noun1: @noun1, noun2: @noun2, verb1: @verb1, verb2: @verb2, adj: @adj, propNoun: @propNoun, noun1_adj1: @noun1_adj1, noun2_verb1: @noun2_verb1, noun2_verb2: @noun2_verb2, verb1_verb1: @verb1_verb1, verb2_verb1: @verb2_verb1, verb2_noun1: @verb2_noun1
end

def gangsta_paradise

	@noun1 = params[:noun1]
	@noun2 = params[:noun2]
	@verb1 = params[:verb1]
	@verb2 = params[:verb2]
	@adj = params[:adj]
	@propNoun = params[:propNoun]
	@noun1_adj1 = params[:noun1_adj1]
	@noun2_verb1 = params[:noun2_verb1]
	@noun2_verb2 = params[:noun2_verb2]
	@verb1_verb1 = params[:verb1_verb1]
	@verb2_verb1 = params[:verb2_verb1]
	@verb2_noun1 = params[:verb2_noun1]

	@sharable_link = request.original_url

end

def juicy_prep

	@noun1 = params[:noun1]
	@noun2 = params[:noun2]
	@verb1 = params[:verb1]
	@verb2 = params[:verb2]
	@adj = params[:adj]
	@propNoun = params[:propNoun]

	@noun1rhymes = getRhymes(@noun1)
	@noun2rhymes = getRhymes(@noun2)
	@verb1rhymes = getRhymes(@verb1)
	@verb2rhymes = getRhymes(@verb2)
	@adjrhymes = getRhymes(@adj)

	# @noun1_nouns = getNouns(@noun1rhymes.join(','))
	# @n1_n1_idx = RandomInteger(@noun1_nouns)
	# @n1_n2_idx = RandomInteger(@noun1_nouns)

	@noun1_nouns = getNouns(@noun1rhymes.join(','))
	@noun1_noun1 = @noun1_nouns[RandomInteger(@noun1_nouns)]
	@noun1_noun2 = @noun1_nouns[RandomInteger(@noun1_nouns)]

	# @noun2_nouns = getNouns(@noun2rhymes.join(','))
	# @n2_n1_idx = RandomInteger(@noun2_nouns)
	# @n2_n2_idx = RandomInteger(@noun2_nouns)

	@noun2_nouns = getNouns((@noun2rhymes.join(',')))
	@noun2_noun1 = @noun2_nouns[RandomInteger(@noun2_nouns)]
	@noun2_noun2 = @noun2_nouns[RandomInteger(@noun2_nouns)]


	# @verb1_verbs = getVerbs(@verb1rhymes.join(','))
	# @verb1_nouns = getNouns(@verb1rhymes.join(','))
	# @v1_v1_idx = RandomInteger(@verb1_verbs)
	# @v1_n1_idx = RandomInteger(@verb1_nouns)

	@verb1_verbs = getVerbs(@verb1rhymes.join(','))
	@verb1_nouns = getNouns(@verb1rhymes.join(','))
	@verb1_verb1 = @verb1_verbs[RandomInteger(@verb1_verbs)]
	@verb1_noun1 = @verb1_nouns[RandomInteger(@verb1_nouns)]

	# @verb2_nouns = getNouns(@verb2rhymes.join(','))
	# @v2_n1_idx = RandomInteger(@verb2_nouns)

	@verb2_nouns = getNouns(@verb2rhymes.join(','))
	@verb2_noun1 = @verb2_nouns[RandomInteger(@verb2_nouns)]

	# @adj_nouns = getNouns(@adjrhymes.join(','))
	# @adj_n1_idx = RandomInteger(@adj_nouns)
	# @adj_n2_idx = RandomInteger(@adj_nouns)

	@adj_nouns = getNouns(@adjrhymes.join(','))
	@adj_noun1 = @adj_nouns[RandomInteger(@adj_nouns)]
	@adj_noun2 = @adj_nouns[RandomInteger(@adj_nouns)]

	redirect_to controller: 'home', action: 'juicy', noun1: @noun1, noun2: @noun2, verb1: @verb1, verb2: @verb2, adj: @adj, propNoun: @propNoun, noun1_noun1: @noun1_noun1, noun1_noun2: @noun_noun2, noun2_noun1: @noun2_noun1, noun2_noun2: @noun2_noun2, verb1_verb1: @verb1_verb1, verb1_noun1: @verb1_noun1, verb2_noun1: @verb2_noun1, adj_noun1: @adj_noun1, adj_noun2: @adj_noun2


end

def juicy
	
	@noun1 = params[:noun1]
	@noun2 = params[:noun2]
	@verb1 = params[:verb1]
	@verb2 = params[:verb2]
	@adj = params[:adj]
	@propNoun = params[:propNoun]
	@noun1_noun1 = params[:noun1_noun1]
	@noun1_noun2  = params[:noun1_noun2]
	@noun2_noun1 = params[:noun2_noun1] 
	@noun2_noun2 = params[:noun2_noun2]   
	@verb1_verb1 = params[:verb1_verb1]
	@verb1_noun1 = params[:verb1_noun1]
	@verb2_noun1 = params[:verb2_noun1]
	@adj_noun1 = params[:adj_noun1]
	@adj_noun2 = params[:adj_noun2]
	
	@sharable_link = request.original_url
end

def lose_yourself_prep

	@noun1 = params[:noun1]
	@noun2 = params[:noun2]
	@verb1 = params[:verb1]
	@verb2 = params[:verb2]
	@adj = params[:adj]
	@propNoun = params[:propNoun]

	@noun1rhymes = getRhymes(@noun1)
	@noun2rhymes = getRhymes(@noun2)
	@verb1rhymes = getRhymes(@verb1)
	@verb2rhymes = getRhymes(@verb2)
	@adjrhymes = getRhymes(@adj)

	@noun1_nouns = getNouns(@noun1rhymes.join(','))
	@noun1_adverbs = getSpeechPart(@adjrhymes.map{|x| x + "ly"}.join(','), "rb")
	@noun1_noun1 = @noun1_nouns[RandomInteger@noun1_nouns]
	@noun1_noun2 = @noun1_nouns[RandomInteger@noun1_nouns]
	@noun1_adverb1 = @noun1_adverbs[RandomInteger(@noun1_adverbs)]


	@noun2_adjs = getAdj(@noun2rhymes.join(','))
	@noun2_adj1 = @noun2_adjs[RandomInteger(@noun2_adjs)]
	@noun2_adj2 = @noun2_adjs[RandomInteger(@noun2_adjs)]

	@verb1_verbs = getVerbs(@verb1rhymes.join(','))
	@verb1_verb1 = @verb1_verbs[RandomInteger(@verb1_verbs)]

	#Nothing for verb2

	@adj_adjs = getAdj(@adjrhymes.join(','))
	@adj_nouns = getNouns(@adjrhymes.join(','))
	@adj_adj1 = @adj_adjs[RandomInteger(@adj_adjs)]
	@adj_adj2 = @adj_adjs[RandomInteger(@adj_adjs)]

	@adj_noun1 = @adj_nouns[RandomInteger(@adj_nouns)]
	@adj_noun2 = @adj_nouns[RandomInteger(@adj_nouns)]


	redirect_to controller: "home", action: "lose_yourself", noun1: @noun1, noun2: @noun2, verb1: @verb1, verb2: @verb2, adj: @adj, propNoun: @propNoun, noun1_noun1: @noun1_noun1, noun1_noun2: @noun1_noun2, noun1_adverb1: @noun1_adverb1, noun2_adj1: @noun2_adj1, noun2_adj2: @noun2_adj2, verb1_verb1: @verb1_verb1, adj_adj1: @adj_adj1, adj_adj2: @adj_adj2, adj_noun1: @adj_noun1, adj_noun2: @adj_noun2
end

def lose_yourself

	@noun1 = params[:noun1]
	@noun2 = params[:noun2]
	@verb1 = params[:verb1]
	@verb2 = params[:verb2]
	@adj = params[:adj]
	@propNoun = params[:propNoun]
	@noun1_noun1 = params[:noun1_noun1]
	@noun1_noun2 = params[:noun1_noun2]
	@noun2_adj1 = params[:noun2_adj1]
	@noun2_adj2 = params[:noun2_adj2]
	@verb1_verb1 = params[:verb1_verb1]
	@adj_adj1 = params[:adj_adj1]
	@adj_adj2 = params[:adj_adj2]
	@adj_noun1 = params[:adj_noun1]
	@adj_noun2 = params[:adj_noun2]
	@noun1_adverb1 = params[:noun1_adverb]

	@sharable_link = request.original_url

	end
end #Ends the document
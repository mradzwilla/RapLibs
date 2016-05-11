$(document).ready(function(){

var prevent = function(event) {

	if ($('#propNoun').val().length === 0) {
		event.preventDefault();
  		event.stopPropagation();
		}
}

$('.raplibs').click(function(){
	window.location.replace("/");
});

$('.raplibs').hide().fadeIn(2000)
$('#flow').hide()

$('#rap_animate').css({
		'animation': 'backshadow 1s infinite'
	})

	$('#libs_animate').css({
		'animation': 'textgrow 1s infinite'
	})

$("#flow").click(function(){
		
	$(".raplibs").animate({
		'margin-top' : '20px',
		'padding-right':'0px'
	})

	$('.libs').css({
		'animation':'none'
	}).animate({
		"font-size": "27px",
		"margin-left": "-5px"
	})

	$('.rap').css({
		'animation':'none'
	}).animate({
		"font-size": "60px",
		"height": "127.219px",
		"width": "128px",
	});

	$('.flowButton').animate({
		'margin-top': '80px'
	})
})

$('#flow').fadeIn()


var phrases = ["Mic check 1, 2, 1, 2...", "Yo. Check it...", "Uh yeah. Here's how it goes down...", "Imma about to tear this track up...", "Where's my snare?","Uh yeah. Yeah. Uhh. Ya'know.", "I'm not a rapper.", "There's no snare in my headphones...", "Representin' the thesaurus", "Word to your mother", "Bayba-Baaayybay", "Yeeaahhhh! Okkkkkkkkkkkkkkkk!", "Turn that beat up!", "Word up", "Ya know what I'm sayin'?", "Check it out", "This is how we do right here."]

var randIdx = function(){
	return Math.floor(Math.random() * phrases.length)
}

$('#flow').bind('click', prevent);
$('.input_section').hide();
$('#about').hide();
$("#noun1").hide();
$("#verb1").hide();
$("#noun2").hide();
$("#verb2").hide();
$("#adj").hide();
$("#propNoun").hide();


$("#about_link").click(function(){

	if ($("#about").is(':hidden')){	
		$('#about').slideDown();
	} else {
		$('#about').slideUp();
	}
})

$('#about_back').click(function(){
		$('#about').slideUp();
})

$("#flow").one("click", function(){

	var beat_library = ["pvhhcl2627yazg2/therealest", "8vmyvlqwz7nlt12/thee_banger","no02hwo57hy091o/the_beginning","34ec2w4i4559wf3/the_one.mp3","3pod9ri9u4c7ftz/so_real", "czmb1he4zwweqqy/newboys","e82kgemj5zbuu5e/Im_the_king","b38qdxk23t1tc8f/hippop", "zxa92zwuuvim975/feelin_it", "3grl7au2fhzzhas/extravagant", "macwzw0k1wbhevy/epic", ]
	
	var songPath = beat_library[Math.floor(Math.random()*(beat_library.length))]
	$('.audio_player').append("<audio autoplay><source src='https://www.dropbox.com/s/" + songPath + ".mp3?raw=1' type='audio/mp3'>")
})

$("#flow").click(function(){

	$('.input_section').fadeIn();
	$('.fill_text').html("DJ drop a beat!")
	setTimeout(function(){
		$('.fill_text').fadeOut();
		$('#flow').attr('value',"Keep spittin'");
		$("#noun1").fadeIn();
	},2500)
})

$("#flow").click(function(event){

	if ($('#noun1').val().length !== 0){

		$("#noun1").hide();
		$('.fill_text').html(phrases[randIdx()]).fadeIn();
		setTimeout(function(){
			$('.fill_text').hide();
			$("#verb1").fadeIn();
			},2000)	
			}
	})

$("#flow").click(function(){

	if ($('#verb1').val().length !== 0){

		$("#verb1").hide();
		$('.fill_text').html(phrases[randIdx()]).fadeIn()

		setTimeout(function(){
			$('.fill_text').hide();
			$("#noun2").fadeIn();
			},2000)
		}
	})

$("#flow").click(function(){

	if ($('#noun2').val().length !== 0) {

		$("#noun2").hide();
		$('.fill_text').html(phrases[randIdx()]).fadeIn();

		setTimeout(function(){
			$('.fill_text').hide();
			$("#verb2").fadeIn();
			},2000)
		}
	})

$("#flow").click(function(){

	if ($('#verb2').val().length !== 0) {

		$("#verb2").hide();
		$('.fill_text').html(phrases[randIdx()]).fadeIn();

		setTimeout(function(){
			$('.fill_text').hide();
			$("#adj").fadeIn();
			},2000)
			}
	})

$("#flow").click(function(){

	if ($('#adj').val().length !== 0){

		$("#adj").hide();
		$('.fill_text').html(phrases[randIdx()]).fadeIn();

		setTimeout(function(){
			$('.fill_text').fadeOut();
			$("#propNoun").fadeIn();
		},2000)

				$("#flow").click(function(){

					if ($('#propNoun').val().length !== 0) {
						$('#propNoun').hide();
						$('form').hide();

						setInterval(function(){
							$('.fill_text').html(phrases[randIdx()]).fadeIn()
							},2000)
						}
				})
	}
})

}) //Closes .ready
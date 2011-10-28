$(function(){
	$('.scuzz_img_block').mouseenter(function(){
		$(this).append($("<input type='button' value='share' class='share_button'>"))
		console.log('hoohh')
	})

	$('.scuzz_img_block').mouseleave(function(){
		$(".share_button").remove()

	})
})

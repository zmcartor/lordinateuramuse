$(function(){
	$('.scuzz_img_block').mouseenter(function(){

		//if link has been shared, data element will say 'shared'
		if(!$(this).hasClass('shared')){
		$(this).append($("<input type='button' value='share' class='share_button'>"))
		$(".share_button").click(function(){
		button = $(this)
		$.ajax({
			url: "/recommend",
			type: "POST",
			data: {url:$(this).siblings('a').attr('href')},
			success: function(){
				$(button).parent().addClass('shared')
				$(button).remove()
			}
		})
	})
}// if shared check

	});


	$('.scuzz_img_block').mouseleave(function(){
		$(".share_button").remove()

	})
	

});

$(function(){
	$('.scuzz_img_block').mouseenter(function(){

		//if link has been shared, data element will say 'shared'
		if(!$(this).hasClass('voted')){
		$(this).append($("<input type='button' value='UP' class = 'arrow up'>"))
		$(this).append($("<input type='button' value='DOWN' class = 'arrow down'>"))
		
		$(".arrow").click(function(){
			button = $(this)
			post_url = $(this).hasClass('up')? '/upvote': '/downvote'
			$.ajax({
				url: post_url,
				type: "POST",
				data: {url:$(this).siblings('a').attr('href')},
				success: function(){}
			})

			$(button).parent().addClass('voted')
			$('.arrow').remove()


		})
		}// if voted check
	})

	$('.scuzz_img_block').mouseleave(function(){
		$(".arrow").remove()

	})



})

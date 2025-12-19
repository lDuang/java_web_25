$(function(){	
	$(".vote").click(function(){	
		var self = $(this);
		if (self.data("voted")) {
			return;
		}
		$.ajax({
			"url": "count.jsp",
        	"type": "post",
        	"data":{'id': self.data("id")},
        	"success":function(data){
        		self.prev().html(data.trim());
				self.data("voted", true);
				self.prop("disabled", true);
        	}
		})		
	})
})

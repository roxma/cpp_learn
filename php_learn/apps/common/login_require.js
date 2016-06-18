
jQuery.ajax({
	  url: "/php_learn/apps/common/login_request.php"
	, success: function(response){
		if(response.user == ""){
			jQuery("body").html("");
			var mail = "";
			while(mail==""){
				mail = prompt("您还没有登录，请输入您的邮箱","");
			}
			jQuery.ajax({
				  url: "/php_learn/apps/common/login_request.php"
				, data:{ mail:mail, return_page: window.location.href }
				, success: function(response){
					if(!response.result){
						return ;
					}
					alert("已经发送验证邮件到您的邮箱，请在同一浏览器中验证登录");

					setInterval(function(){
						jQuery.ajax({
							  url: "/php_learn/apps/common/login_request.php"
							, success: function(response){
								if(response.user != ""){
									window.location.reload();
								}
							}
						});	
					}, 1500);
				}
			});
		}
	}
});

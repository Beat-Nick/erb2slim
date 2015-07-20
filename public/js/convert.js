$(function (){
	$('#convert').submit(function(ev){
  	//prevent the default behavior of a form
  	ev.preventDefault();
  
  	//send an ajax request to our action
  	$.ajax({
    	url: "/convert.json",
    
    	//serialize the form and use it as data for our ajax request
    	data: $(this).serialize(),
    
    	//the type of data we are expecting back from server
    	dataType: "json",

    	success: function(data) {
    			$( "#final" ).val(data.converted_text);
    	}
  	});
	});
}); 

//Nav Bar
//$( ".nav-li" ).removeClass( "active" )
//$( "#" + window.location.pathname.replace(/^\/([^\/]*).*$/, '$1')).addClass( "active" )

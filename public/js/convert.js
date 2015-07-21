$(function (){
  ///////////////////////
  //CodeMirror
  //////////////////////
  rconfig = {
    lineNumbers: true,
    value: "work",
    mode: "htmlembedded"
  };
  cconfig = {
    lineNumbers: true,
    mode: "application/x-slim"
   };

  raw_text = CodeMirror.fromTextArea(document.getElementById("raw_text"), rconfig);
  convert = CodeMirror.fromTextArea(document.getElementById("final"), cconfig);
  
  raw_text.setSize(null, "88%");
  convert.setSize(null, "88%");

  // $( window ).resize(function() {
  //   raw_text.setSize("", "88%");
  //   convert.setSize("", "88%");
  // });
  
  ///////////////////////
  //AJAX
  //////////////////////
	$('#convert').submit(function(ev){
  	//prevent the default behavior of a form
  	ev.preventDefault();
  
    alert( $(this).serialize());
  	//send an ajax request to our action
  	$.ajax({
      type: "POST",
    	url: "/convert.json",
    

    	//serialize the form and use it as data for our ajax request
    	data: $(this).serialize(),
    
    	//the type of data we are expecting back from server
    	dataType: "json",

    	success: function(data) {
    			convert.getDoc().setValue(data.converted_txt);
    	}
  	});
	});
  
}); 

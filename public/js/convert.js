$(function (){
  ///////////////////////
  //CodeMirror
  //////////////////////
  rconfig = {
    lineNumbers: true,
    value: "work",
    mode: "htmlembedded"
    //theme: "ambiance",
    //indentWithTabs: false,
    //readOnly: true
  };

  raw_text = CodeMirror.fromTextArea(document.getElementById("raw_text"), rconfig);

  cconfig = {
    lineNumbers: true,
    mode: "application/x-slim"
   };

  convert = CodeMirror.fromTextArea(document.getElementById("final"), cconfig);
  
  ///////////////////////
  //AJAX
  //////////////////////
	$('#convert').submit(function(ev){
  	//prevent the default behavior of a form
  	ev.preventDefault();
  
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

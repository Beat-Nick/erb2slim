$(function (){
  ///////////////////////
  //Page Setup
  //////////////////////  
  $('input:radio[id=haml2slim]').prop( "checked", true);
  
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
   };

  raw_text = CodeMirror.fromTextArea(document.getElementById("raw_text"), rconfig);
  convert = CodeMirror.fromTextArea(document.getElementById("final"), cconfig);
  
  //viewport height hack because i'm tired of design
  raw_text.setSize(null, "87vh");
  convert.setSize(null, "87vh");
  
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
          //set codemirror mode
          if($('#haml').prop( "checked" )) {
            convert.setOption("mode", "haml");
          }else {
            convert.setOption("mode", "application/x-slim");
          }

          //set codemirror value to converted text
    			convert.getDoc().setValue(data.converted_txt);
    	}
  	});
	});
  
}); 

//Toggle Advanced options depending on conversion type
$("input:radio[name='conversion_type']").change(function(e){
    if($(this).val() == 'slim') {
      $("input:checkbox").attr('disabled', 'disabled');
    } else {
      $("input:checkbox").removeAttr('disabled');
    }
});
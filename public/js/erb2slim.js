var html = "<html> \r\n \
  <head> \r\n \
    <title>Enter Your Code Here</title> \r\n \
  <%= foo = [1,2,3] %>\r\n \
  <body> \r\n \
    <%= foo.each do |bar| %> \r\n \
    <p>Or click Convert to test it out!</p> \r\n \
  </body> \r\n \
  </head> \r\n \
</html>";

///////////////////////
//Page Setup
//////////////////////
$(function (){
  $('input:radio[id=haml2slim]').prop( "checked", true);
  $("input:checkbox[id=indent]").attr('disabled', 'disabled');
  $('input:checkbox[id=theme]').prop( "checked", true);

  ///////////////////////
  //CodeMirror
  //////////////////////
  rconfig = {
    lineNumbers: true,
    styleSelectedText: true,
    ///mode: "htmlembedded",
    theme: "railscasts"
  };
  cconfig = {
    lineNumbers: true,
    styleSelectedText: true,
    theme: "railscasts"
   };

  raw_text = CodeMirror.fromTextArea(document.getElementById("raw_text"), rconfig);
  convert = CodeMirror.fromTextArea(document.getElementById("final"), cconfig);

  raw_text.setSize(null, "calc(92% - 5px)");
  raw_text.setValue(html);
  convert.setSize(null, "calc(92% - 5px)");

  ///////////////////////
  //AJAX CALL FOR CONVERSION
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
          //set codemirror syntax highlighting
          if($('#haml').prop( "checked" )) {
            convert.setOption("mode", "haml");
          }else {
            convert.setOption("mode", "application/x-slim");
          }

          //set codemirror value to converted text
    			convert.getDoc().setValue(data.converted_txt);

          //load new conversion count into ticker
          $('.tick').attr("data-value", data.conversion_cnt)
    	}
  	});
	});

});

//Toggle Advanced options depending on conversion type
$("input:radio[name='conversion_type']").change(function(e){
    $('input:checkbox').removeAttr('checked');
    if($(this).val() == 'slim') {
      $("input:checkbox[id=erb]").attr('disabled', 'disabled');
      $("input:checkbox[id=xhtml]").attr('disabled', 'disabled');
      $("input:checkbox[id=ruby]").attr('disabled', 'disabled');
      $("input:checkbox[id=indent]").attr('disabled', 'disabled');
    }
    else if($(this).val() == 'format') {
      
      $("input:checkbox").attr('disabled', 'disabled');
      $("input:checkbox[id=theme]").removeAttr('disabled');
      $("input:checkbox[id=indent]").removeAttr('disabled');
    } else {
      $("input:checkbox").removeAttr('disabled');
      $("input:checkbox[name=indent]").attr('disabled', 'disabled');
    }
});

//Toggle sidebar icon colors
$( ".git" ).hover(function() {
    $("#gh" ).attr( "src", "/img/gh32black.png");
  }, function() {
    $( "#gh" ).attr("src", "/img/gh32white.png");
  }
);
$( ".report" ).hover(
  function() {
    $("#report" ).attr( "src", "/img/alert32black.png");
  }, function() {
    $("#report" ).attr( "src", "/img/alert32white.png");
  }
);

	var button1 = document.getElementById("r1");
	var button2 = document.getElementById("r2");
	var button3 = document.getElementById("r3");
	var val1;
	var val2;
	var result;


jQuery(	document).ready(function(){
	
	
	$('#v1').on("keyup",function(e){
				e.preventDefault();
				val1 = $('#v1').val();
				console.log( val1 );
				calculate();
				});
				
	$('#v2').on("keyup",function(e){
				e.preventDefault();
				val2 = $('#v2').val();
				calculate();
				console.log( val2 );
				});
				
	$("#r1, #r2, #r3").on("click", function(){
		calculate();
		console.log("clicked");
	})
	
	
	var calculate = function(){
	console.log( button1.checked );
			
			if (button1.checked){
			
			result = parseInt($('#v1').val()) + parseInt($('#v2').val());
			console.log( result);
			$('#res').val(result);
			
    			
			}else if (button2.checked) {
    				
    			result = val1 * val2;
			$('#res').val(result);
    				
    				
			}else if(button3.checked) {
			
			
			result = val1 / val2;
			$('#res').val(result);
			
			
			
			}else {
			alert("Please Select an Operation");
			}
			
			}
			
});
			

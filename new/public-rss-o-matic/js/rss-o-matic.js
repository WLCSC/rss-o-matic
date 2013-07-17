$(document).ready (function() {
	var element_height = document.getElementById('i-cont').offsetHeight;

	console.log(element_height + "\n");
	
	$('#i-cont').animate ({'top' : -(element_height - (768 - (64 + 24)))}, 6000, "linear");
});

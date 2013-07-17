function populate_datetime()
{
	var cd = new Date();
	var month = "" + (cd.getMonth() + 1);
	var day = "" + cd.getDate();
	var hour = "" + cd.getHours();
	var minute = "" + cd.getMinutes();
	var pad = "00";
	month = pad.substring(0, pad.length - month.length) + month;
	day = pad.substring(0, pad.length - day.length) + day;
	hour = pad.substring(0, pad.length - hour.length) + hour;
	minute = pad.substring(0, pad.length - minute.length) + minute;
	document.getElementById("date-time").innerHTML =
		cd.getFullYear() +
		"-" +
		month +
		"-" +
		day +
		"<br />" +
		hour +
		":" +
		minute;
}

$(document).ready (function() {
	populate_datetime();
});

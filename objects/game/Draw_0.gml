/// @desc <>

if room == rm_end {
	var clockSecond = global.time / 1000000;
	var clockMinute
	var clockHour
	
	if clockSecond >= 60 {
		clockSecond = 0;
		clockMinute ++;
	}

	if clockMinute >= 60 {
		clockMinute = 0;
		clockHour++;
	}
	draw_text_ext(room_width / 2, room_height - 200,  string(clockHour) + " : " + string(clockMinute) + " : " + string(clockSecond), 5, 200);
}
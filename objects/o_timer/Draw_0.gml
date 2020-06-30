/// @desc <>

clockSecond = timer / 1000000;

if clockSecond >= 60 {
	clockSecond = 0;
	clockMinute ++;
}

if clockMinute >= 60 {
	clockMinute = 0;
	clockHour++;
}

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_ext(room_width / 2 - 50, 98, string(clockHour) + " : " + string(clockMinute) + " : " + string(clockSecond), 5, 200);
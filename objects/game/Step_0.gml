/// @desc <>
scr_system_code();

if keyboard_check_pressed(vk_space) and room != rm_main {
	room_goto_next();
}

if room == rm_end and keyboard_check_pressed(ord("R")) {
	room_goto(rm_main);
}
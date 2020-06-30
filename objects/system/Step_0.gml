/// @desc 

#region temp code
#region right click to creat a block
/*
//temp code to create blocks w/ right click
if keyboard_check_pressed(ord("1")) {
	spawn_block = 1;
} else if keyboard_check_pressed(ord("2")) {
	spawn_block = 2;
} else if keyboard_check_pressed(ord("3")) {
	spawn_block = 3;
} else if keyboard_check_pressed(ord("4")) {
	spawn_block = 4;
} else if keyboard_check_pressed(ord("5")) {
	spawn_block = 5;
} 
var _index = s_block_red;
if mouse_check_button_pressed(mb_right) and instance_position(mouse_x, mouse_y, o_block) == noone {
	switch spawn_block {
		case 1:
		_index = s_block_red;
		break;
		case 2:
		_index = s_block_yellow;
		break;
		case 3:
		_index = s_block_green;
		break;
		case 4:
		_index = s_block_blue;
		break;
		case 5:
		_index = s_block_purple;
		break;
	}
	var _block = instance_create_layer(mouse_x div 64 * 64, mouse_y div 64 * 64, "Instances", o_block);
	_block.sprite_index = _index; 
	ds_grid_add(global.grid, mouse_x div 64, mouse_y div 64, spawn_block);
}
*/
#endregion

//Fill all with random index on space
if room == rm_main and spawn_block == true {
	spawn_block = false;
	
	ds_grid_resize(global.grid, ds_grid_width(global.grid) - 2, ds_grid_height(global.grid) - 2)
	for (var _x = 0; _x < ds_grid_width(global.grid); _x++) {
		for (var _y = 0; _y < ds_grid_height(global.grid); _y++) {
			if ds_grid_get(global.grid, _x, _y) == 0 {
				ds_grid_set(global.grid, _x, _y, irandom_range(1,19));
				ds_grid_set(global.grid, _x, _y + 1, ds_grid_get(global.grid, _x, _y));
			}
		}
	}
	
	//randomize grid
	ds_grid_shuffle(global.grid);
	ds_grid_resize(global.grid, 15, 10)
	
	//move grid to center
	ds_grid_set_grid_region(global.grid, global.grid, 0, 0, ds_grid_width(global.grid) - 2, ds_grid_height(global.grid) - 2, 1, 1);
	
	#region trim the rim
	
	//trim the rim
	ds_grid_set_region(global.grid, 0, 0, ds_grid_width(global.grid) - 1, 0, 0);
	ds_grid_set_region(global.grid, 0, ds_grid_height(global.grid) - 1, ds_grid_width(global.grid) - 1, ds_grid_height(global.grid) - 1, 0);
	ds_grid_set_region(global.grid, 0, 0, 0, ds_grid_height(global.grid) - 1, 0);
	ds_grid_set_region(global.grid, ds_grid_width(global.grid) - 1, 0, ds_grid_width(global.grid), ds_grid_height(global.grid) - 1, 0);
	
	#endregion
	//fill the grid with o_blocks
	for (var _x = 1; _x < ds_grid_width(global.grid) - 1; _x++) {
		for (var _y = 1; _y < ds_grid_height(global.grid) - 1; _y++) {
			if ds_grid_get(global.grid, _x, _y) != 0 {
				var _block = instance_create_layer(_x * cell_size + grid_xoffset, _y * cell_size + grid_yoffset, "Instances", o_block);
				scr_switch_colour(ds_grid_get(global.grid, _x, _y));
				_block.sprite_index = spawn_index;
			}
		}
	}
}
#endregion

#region Block Selection + (main logic -> in script)
leftClick = mouse_check_button_pressed(mb_left);

//selecting first block
var _selecting1stBlock = (leftClick and position_meeting(mouse_x, mouse_y, o_block)) and select1 == false;
if _selecting1stBlock {
	select1 = true;
	block1 = instance_position(mouse_x, mouse_y, o_block);
	block1.image_index = !block1.image_index;
	xpos1 = (mouse_x div cell_size) + pix_xoffset;
	ypos1 = (mouse_y div cell_size) + pix_yoffset;
	show_debug_message("xpos1 = " + string(xpos1));
	show_debug_message("ypos1 = " + string(ypos1));
}

//selecting second block
var _selecting2ndBlock = ((leftClick and position_meeting(mouse_x, mouse_y, o_block)) and instance_position(mouse_x, mouse_y, o_block) != block1) and select2 == false;
if _selecting2ndBlock {
	select2 = true;
	block2 = instance_position(mouse_x, mouse_y, o_block);
	if block1.sprite_index != block2.sprite_index {
		scr_clear_selection();
		exit;
	}
	block2.image_index = !block2.image_index;
	xpos2 = (mouse_x div cell_size) + pix_xoffset;
	ypos2 = (mouse_y div cell_size) + pix_yoffset;
	show_debug_message("xpos2 = " + string(xpos2));
	show_debug_message("ypos2 = " + string(ypos2));
	
	//main game logic
	scr_game_logic();
}

//clear all selection
// if it is not block1 and not block2 and u did select a block then clear all
var _selecting3rdBlock = (instance_position(mouse_x, mouse_y, o_block) != block1 and instance_position(mouse_x, mouse_y, o_block) != block2) and leftClick 
if _selecting3rdBlock {
		scr_clear_selection();
}
#endregion

#region game ending
if ds_grid_get_sum(global.grid, 0, 0, ds_grid_width(global.grid), ds_grid_height(global.grid)) == 0 {
	room_goto_next();
}
#endregion

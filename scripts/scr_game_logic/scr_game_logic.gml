//checking for if the blocks can be broken

#region Straight Clear
//same row
if ypos1 == ypos2 {
	var _sum = 0;
	for (var xx = min(xpos1, xpos2) + 1; xx < max(xpos1, xpos2); xx++) {
		var _num = ds_grid_get(global.grid, xx, ypos1);
		_sum += _num
		//show_debug_message(string(_sum));
	}
	
	if _sum <= 0 {		
		scr_delete_block();
		exit;
	}
}


//same column
if xpos1 == xpos2 {
	var _sum = 0;
	for (var yy = min(ypos1, ypos2) + 1; yy < max(ypos1, ypos2); yy++) {
		var _num = ds_grid_get(global.grid, xpos1, yy);
		_sum += _num
		//show_debug_message(string(_sum));
	}
	
	if _sum <= 0 {		
		scr_delete_block();
		exit;
	}
}
#endregion
#region 1 Turn Clear
if ypos1 != ypos2 and xpos1 != xpos2{
	#region Left right first
	//checking left and right of block1
	var _sumxR = 0;
	var _sumxL = 0;
	for (var _x = 1; _x < abs(xpos1 - xpos2); _x++) {
		if xpos2 > xpos1 {
			var _numxR = ds_grid_get(global.grid, xpos1 + _x, ypos1);
			_sumxR += _numxR;
			//show_debug_message("sumxR = " + string(_sumxR));
		} else if xpos2 < xpos1 {
			var _numxL = ds_grid_get(global.grid, xpos1 - _x, ypos1);
			_sumxL += _numxL;
			//show_debug_message("sumxL = " + string(_sumxL));
		}
	}
	
	var _sumyUp = 0;
	var _sumyDown = 0;
	for (var _y = 0; _y < abs(ypos1- ypos2); _y++) {
		if ypos2 > ypos1 {
			var _numyDown = ds_grid_get(global.grid, xpos2, ypos1 + _y);
			_sumyDown += _numyDown;
			//show_debug_message("sumyDown = " + string(_sumyDown));
		} else if ypos2 < ypos1 {
			var _numyUp = ds_grid_get(global.grid, xpos2, ypos1 - _y);
			_sumyUp += _numyUp;
			//show_debug_message("sumyUp = " + string(_sumyUp));
		}
	}

	if xpos2 > xpos1 { //right path
		if ypos2 > ypos1 { //down path
			if _sumxR == 0 and _sumyDown == 0 {
				scr_delete_block();
				exit;
			}
		} else if ypos2 < ypos1 { //up path
			if _sumxR == 0 and _sumyUp == 0 {
				scr_delete_block();
				exit;
			}
		}
	} else if xpos2 < xpos1 { //left path
		if ypos2 > ypos1 { //down path
			if _sumxL == 0 and _sumyDown == 0 {
				scr_delete_block();
				exit;
			}
		} else if ypos2 < ypos1 { //up path
			if _sumxL == 0 and _sumyUp == 0 {
				scr_delete_block();
				exit;
			}
		}
	}
	#endregion
	#region Up down first
	//checking up and down first of block1
	var _sumxR = 0;
	var _sumxL = 0;
	for (var _x = 0; _x < abs(xpos1 - xpos2); _x++) {
		if xpos2 > xpos1 {
			var _numxR = ds_grid_get(global.grid, xpos1 + _x, ypos2);
			_sumxR += _numxR;
			//show_debug_message("sumxR = " + string(_sumxR));
		} else if xpos2 < xpos1 {
			var _numxL = ds_grid_get(global.grid, xpos1 - _x, ypos2);
			_sumxL += _numxL;
			//show_debug_message("sumxL = " + string(_sumxL));
		}
	}
	
	var _sumyUp = 0;
	var _sumyDown = 0;
	for (var _y = 1; _y < abs(ypos1 - ypos2); _y++) {
		if ypos2 > ypos1 {
			var _numyDown = ds_grid_get(global.grid, xpos1, ypos1 + _y);
			_sumyDown += _numyDown;
			//show_debug_message("sumyDown = " + string(_sumyDown));
		} else if ypos2 < ypos1 {
			var _numyUp = ds_grid_get(global.grid, xpos1, ypos1 - _y);
			_sumyUp += _numyUp;
			//show_debug_message("sumyUp = " + string(_sumyUp));
		}
	}
	
	if  ypos2 < ypos1 { //up path
		if xpos2 > xpos1 { //right path
			if _sumxR == 0 and _sumyUp == 0 {
				scr_delete_block();
				exit;
			}
		} else if xpos2 < xpos1 { //left path
			if _sumxL == 0 and _sumyUp == 0 {
				scr_delete_block();
				exit;
			}
		}
	} else if ypos2 > ypos1 { //down path
		if xpos2 > xpos1 { //right path
			if _sumxR == 0 and _sumyDown == 0 {
				scr_delete_block();
				exit;
			}
		} else if xpos2 < xpos1 { //left path
			if _sumxL == 0 and _sumyDown == 0 {
				scr_delete_block();
				exit;
			}
		}
	}
	#endregion
}
#endregion
#region 2 Turn Clear
#region logic explenation
/*
(for 2 vertical line and 1 horizontal line clears)
First check for all rows between block1 and block2 if there's a empty row inbetween them
if the above is true, then save that empty row to a list of the same size as the height of the grid
check to find the y position of the list to see which y position is empty
for that y position check to see if the column from block1 to the y position and block2 to the yposition are empty
if that's true then clear block
*/
#endregion
#region 1 horizontal line 2 vertical line
var _turnCondition1H = false;
var _sumx = 0;
//1 horizontal line L to R
var _rowEmpty = ds_list_create();
for (var _y = 0; _y < ds_grid_height(global.grid); _y++) {
	
	//xpos1 on the left going right
	if xpos1 < xpos2 {
		for (var _x = 0; _x <= xpos2 - xpos1; _x ++) {
			var _numx = ds_grid_get(global.grid, xpos1 + _x, _y);
			_sumx += _numx;
			//show_debug_message("on row" + string(_y));
			//show_debug_message("sumx LR =" + string(_sumx));
		}
	}
	//xpos1 on the right going left
	if xpos1 > xpos2 {
		for (var _x = 0; _x <= xpos1 - xpos2; _x ++) {
			var _numx = ds_grid_get(global.grid, xpos2 + _x, _y);
			_sumx += _numx;
			//show_debug_message("on row" + string(_y));
			//show_debug_message("sumx RL=" + string(_sumx));
		}
	}
	
	if _sumx <= 0 {
		_turnCondition1H = true;
		//show_debug_message("turn condition is true");
		ds_list_set(_rowEmpty, _y, true);
	}
	
	_sumx = 0;
	//show_debug_message("new line");
}

var _sumy1 = 0;
var _sumy2 = 0;
if _turnCondition1H {
	for (var _y = 0; _y < ds_list_size(_rowEmpty); _y++) {
		if _rowEmpty[| _y] == true {
			//BLOCK1
			//check if _y is higher than ypos1
			if _y < ypos1 {
				for (var _yy = _y; _yy < ypos1; _yy++) {
					var _numy1 = global.grid[# xpos1, _yy];
					_sumy1 += _numy1;
					//show_debug_message("sumy1 down = " + string(_sumy1));
				}
			} else if _y > ypos1 { //_y is lower than ypos1
				for (var _yy = _y; _yy > ypos1; _yy--) {
					var _numy1 = global.grid[# xpos1, _yy];
					_sumy1 += _numy1;
					//show_debug_message("sumy1 up = " + string(_sumy1));
				}
			}
			
			//BLOCK2
			//check if _y is higher than ypos2
			if _y < ypos2 {
				for (var _yy = _y; _yy < ypos2; _yy++) {
					var _numy2 = global.grid[# xpos2, _yy];
					_sumy2 += _numy2;
					//show_debug_message("sumy2 down = " + string(_sumy2));
				}
			} else if _y > ypos2 { //_y is lower than ypos2
				for (var _yy = _y; _yy > ypos2; _yy--) {
					var _numy2 = global.grid[# xpos2, _yy];
					_sumy2 += _numy2;
					//show_debug_message("sumy2 up = " + string(_sumy2));
				}
			}
			
			if _sumy1 <= 0 and _sumy2 <= 0 {
				scr_delete_block();
				exit;
			}
			
			_sumy1 = 0;
			_sumy2 = 0;
		}
	}
}
#endregion
#region 1 vertical line and 2 horizontal line
var _turnCondition1V = false;
var _sumy = 0;
//1 vertical line up to down
var _colEmpty = ds_list_create();
for (var _x = 0; _x < ds_grid_width(global.grid); _x++) {
	//ypos1 on the top going down to ypos2
	if ypos1 < ypos2 {
		for (var _y = 0; _y <= ypos2 - ypos1; _y ++) {
			var _numy = ds_grid_get(global.grid, _x, ypos1 + _y);
			_sumy += _numy;
			//show_debug_message("on col" + string(_x));
			//show_debug_message("sumu UD =" + string(_sumy));
		}
	}
	//ypos1 on the bottom going up to ypos2
	if ypos1 > ypos2 {
		for (var _y = 0; _y <= ypos1 - ypos2; _y ++) {
			var _numy = ds_grid_get(global.grid, _x, ypos2 + _y);
			_sumy += _numy;
			//show_debug_message("on col" + string(_x));
			//show_debug_message("sumu DU =" + string(_sumy));
		}
	}
	if _sumy <= 0 {
		_turnCondition1V = true;
		//show_debug_message("turn condition is true");
		ds_list_set(_colEmpty, _x, true);
	}
	
	_sumy = 0;
	//show_debug_message("new line");
}

var _sumx1 = 0;
var _sumx2 = 0;
if _turnCondition1V {
	for (var _x = 0; _x < ds_list_size(_colEmpty); _x++) {
		if _colEmpty[| _x] == true {
			//BLOCK1
			//check if _x is left of xpos1
			if _x < xpos1 {
				for (var _xx = _x; _xx < xpos1; _xx++) {
					var _numx1 = global.grid[# _xx, ypos1];
					_sumx1 += _numx1;
					//show_debug_message("sumx1 left = " + string(_sumx1));
				}
			} else if _x > xpos1 { //_x is right of xpos1
				for (var _xx = _x; _xx > xpos1; _xx--) {
					var _numx1 = global.grid[# _xx, ypos1];
					_sumx1 += _numx1;
					//show_debug_message("sumx1 right = " + string(_sumx1));
				}
			}
			
			//BLOCK2
			//check if _x is right of xpos2
			if _x < xpos2 {
				for (var _xx = _x; _xx < xpos2; _xx++) {
					var _numx2 = global.grid[# _xx, ypos2];
					_sumx2 += _numx2;
					//show_debug_message("sumx2 left = " + string(_sumx2));
				}
			} else if _x > xpos2 { //_x is right of xpos2
				for (var _xx = _x; _xx > xpos2; _xx--) {
					var _numx2 = global.grid[# _xx, ypos2];
					_sumx2 += _numx2;
					//show_debug_message("sumx2 right = " + string(_sumx2));
				}
			}
			
			if _sumx1 <= 0 and _sumx2 <= 0 {
				scr_delete_block();
				exit;
			}
			
			_sumx1 = 0;
			_sumx2 = 0;
		}
	}
}
#endregion
#endregion
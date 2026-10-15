/* A Program to Print to console.log a Chess Board   *\
 |* Using spaces and # as the white and black squares *|
 \*                                                   */

var chessBoard = function(boardSize) {
	var i = 0;
	var board = "";
	for (i; i < boardSize; i++) {
		var j = 0;
		var boardRow = "";
		for (j; j < boardSize; j++) {
			if (i % 2 != 0) {
				if (j % 2 != 0) {
					boardRow += "#";
				} else {
					boardRow += " ";
				}
			} else {
				if (j % 2 != 0) {
					boardRow += " ";
				} else {
					boardRow += "#";
				};
			}
		}
		if (i < boardSize - 1) {
			board += boardRow + " \n";
		} else {
			board += boardRow;
		}
	}
	return board;
};

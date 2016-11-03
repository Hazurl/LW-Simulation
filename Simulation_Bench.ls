include("102_Debug");

include("104_SimulateFight");
global debugMapFunction = true;
global debugGetCharacteristic = true;

if (debugMapFunction) {
	debugNotImportant('Map Function');
	debugEvent('getCellContent');
	bench_verify(ToFr_1(getCellContent)(0), CELL_EMPTY, 'Cellule 0');
	bench_verify(ToFr_1(getCellContent)(getCell(getLeek())), CELL_PLAYER,'Cellule with leek');
	bench_verify(ToFr_1(getCellContent)(getObstacles()[0]), CELL_OBSTACLE,'Cellule with obstacle');
	bench_verify(ToFr_1(getCellContent)(-1), -1,'Cellule null');

	debugEvent('isEmptyCell');
	bench_verify(ToFr_1(isEmptyCell)(0), true, 'Cellule 0');
	bench_verify(ToFr_1(isEmptyCell)(getCell(getLeek())), false,'Cellule with leek');
	bench_verify(ToFr_1(isEmptyCell)(getObstacles()[0]), false,'Cellule with obstacle');
	bench_verify(ToFr_1(isEmptyCell)(-1), false,'Cellule null');

	debugEvent('isLeek');
	bench_verify(ToFr_1(isLeek)(0), false, 'Cellule 0');
	bench_verify(ToFr_1(isLeek)(getCell(getLeek())), true, 'Cellule with leek');
	bench_verify(ToFr_1(isLeek)(getObstacles()[0]), false, 'Cellule with obstacle');
	bench_verify(ToFr_1(isLeek)(-1), false,'Cellule null');

	debugEvent('isObstacle');
	bench_verify(ToFr_1(isObstacle)(0), false, 'Cellule 0');
	bench_verify(ToFr_1(isObstacle)(getCell(getLeek())), false, 'Cellule with leek');
	bench_verify(ToFr_1(isObstacle)(getObstacles()[0]), true, 'Cellule with obstacle');
	bench_verify(ToFr_1(isObstacle)(-1), true, 'Cellule null');

	debugEvent('getLeekOnCell');
	bench_verify(ToFr_1(getLeekOnCell)(0), -1,'Cellule 0');
	bench_verify(ToFr_1(getLeekOnCell)(getCell(getLeek())), getLeek(),'Cellule with leek');
	bench_verify(ToFr_1(getLeekOnCell)(getObstacles()[0]), -1, 'Cellule with obstacle');
	bench_verify(ToFr_1(getLeekOnCell)(-1), -1, 'Cellule null');
}
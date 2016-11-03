include("102_Debug");

include("104_SimulateFight");
global debugMapFunction = true;
global debugLeekFunction = true;

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

if (debugLeekFunction) {
	debugNotImportant('Leek Function');

	bench_verify(ToFr_0(getLeek)(), 1000, 'getLeek');

	bench_verify(ToFr_0(getLevel)(), 1000, 'getLevel');

	bench_verify(ToFr_0(getStrenght)(), 1000, 'getStrenght');

	bench_verify(ToFr_0(getLife)(), 1000, 'getLife');

	bench_verify(ToFr_0(getTotalLife)(), 1000, 'getTotalLife');

	bench_verify(ToFr_0(getWisdom)(), 1000, 'getWisdom');

	bench_verify(ToFr_0(getAgility)(), 1000, 'getAgility');

	bench_verify(ToFr_0(getResistance)(), 1000, 'getResistance');

	bench_verify(ToFr_0(getScience)(), 1000, 'getScience');

	bench_verify(ToFr_0(getMagic)(), 1000, 'getMagic');

	bench_verify(ToFr_0(getFrequency)(), 1000, 'getFrequency');

	bench_verify(ToFr_0(getTP)(), 1000, 'getTP');

	bench_verify(ToFr_0(getTotalTP)(), 1000, 'getTotalTP');

	bench_verify(ToFr_0(getMP)(), 1000, 'getMP');

	bench_verify(ToFr_0(getWeapon)(), 1000, 'getWeapon');

	bench_verify(ToFr_0(getWeapons)(), 1000, 'getWeapons');

	bench_verify(ToFr_0(getChips)(), 1000, 'getChips');

	bench_verify(ToFr_0(getSummoner)(), 1000, 'getSummoner');

	bench_verify(ToFr_0(getEffects)(), 1000, 'getEffects');

	bench_verify(ToFr_0(getLaunchedEffects)(), 1000, 'getLaunchedEffects');

	bench_verify(ToFr_0(getBirthTurn)(), 1000, 'getBirthTurn');

	bench_verify(ToFr_0(isSummon)(), 1000, 'isSummon');

	bench_verify(ToFr_0(getType)(), 1000, 'getType');

	bench_verify(ToFr_0(isAlly)(), 1000, 'isAlly');

	bench_verify(ToFr_0(isEnemy)(), 1000, 'isEnemy');
}
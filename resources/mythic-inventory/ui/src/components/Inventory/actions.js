import Nui from '../../util/Nui';

const moveSlot = (
	ownerFrom,
	ownerTo,
	slotFrom,
	slotTo,
	invTypeFrom,
	invTypeTo,
	name,
	countFrom,
	countTo,
	vehClassFrom,
	vehClassTo,
	vehModelFrom,
	vehModelTo,
) => {
	Nui.send('MoveSlot', {
		ownerFrom: ownerFrom,
		ownerTo: ownerTo,
		slotFrom: slotFrom,
		slotTo: slotTo,
		name: name,
		countFrom: countFrom,
		countTo: countTo,
		invTypeFrom: invTypeFrom,
		invTypeTo: invTypeTo,
		vehClassFrom: vehClassFrom,
		vehClassTo: vehClassTo,
		vehModelFrom: vehModelFrom,
		vehModelTo: vehModelTo,
	});
};

const useItem = (ownerFrom, slotFrom, invTypeFrom) => {
	Nui.send('FrontEndSound', 'SELECT');
	Nui.send('UseItem', {
		owner: ownerFrom,
		slot: slotFrom,
		invType: invTypeFrom,
	});
};

const sendNotify = (alt, message, time) => {
	Nui.send('SendNotify', {
		alert: alt,
		message: message,
		time: time,
	});
};

const closeInventory = () => {
	Nui.send('Close');
};

export { moveSlot, useItem, closeInventory, sendNotify };

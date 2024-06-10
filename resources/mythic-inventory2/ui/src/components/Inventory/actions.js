import Nui from '../../util/Nui';

const mergeSlot = (
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
	slotOverrideFrom,
	slotOverrideTo,
	capacityOverrideFrom,
	capacityOverrideTo,
) => {
	Nui.send('MergeSlot', {
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
		slotOverrideFrom: slotOverrideFrom,
		slotOverrideTo: slotOverrideTo,
		capacityOverrideFrom: capacityOverrideFrom,
		capacityOverrideTo: capacityOverrideTo,
	});
};

const swapSlot = (
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
	slotOverrideFrom,
	slotOverrideTo,
	capacityOverrideFrom,
	capacityOverrideTo,
) => {
	Nui.send('SwapSlot', {
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
		slotOverrideFrom: slotOverrideFrom,
		slotOverrideTo: slotOverrideTo,
		capacityOverrideFrom: capacityOverrideFrom,
		capacityOverrideTo: capacityOverrideTo,
	});
};

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
	slotOverrideFrom,
	slotOverrideTo,
	capacityOverrideFrom,
	capacityOverrideTo,
	isSplit = false,
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
		slotOverrideFrom: slotOverrideFrom,
		slotOverrideTo: slotOverrideTo,
		capacityOverrideFrom: capacityOverrideFrom,
		capacityOverrideTo: capacityOverrideTo,
		isSplit,
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

export { mergeSlot, swapSlot, moveSlot, useItem, closeInventory, sendNotify };

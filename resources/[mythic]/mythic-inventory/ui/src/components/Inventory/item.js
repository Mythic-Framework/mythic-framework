const getItemImage = (item, itemData) => {
	if (item?.MetaData?.CustomItemImage) {
		return item?.MetaData?.CustomItemImage;
	} else if (Boolean(itemData) && Boolean(itemData.iconOverride)) {
		return `../images/items/${itemData.iconOverride}.webp`;
	} else {
		return `../images/items/${itemData.name}.webp`;
	}
};

const getItemLabel = (item, itemData) => {
	if (item?.MetaData?.CustomItemLabel) {
		return item?.MetaData?.CustomItemLabel;
	} else {
		return itemData?.label ?? 'Unknown';
	}
};

export { getItemImage, getItemLabel };

const lua2json = (lua) =>
	JSON.parse(
		lua
			.replace(/\[([^\[\]]+)\]\s*=/g, (s, k) => `${k} :`)
			.replace(/,(\s*)\}/gm, (s, k) => `${k}}`),
	);

const getItemImage = (item, itemData) => {
	const metadata = Boolean(item?.MetaData)
		? typeof item?.MetaData == 'string'
			? lua2json(item.MetaData)
			: item.MetaData
		: Object();

	if (metadata?.CustomItemImage) {
		return metadata?.CustomItemImage;
	} else if (Boolean(itemData) && Boolean(itemData.iconOverride)) {
		return `../images/items/${itemData.iconOverride}.webp`;
	} else {
		return `../images/items/${itemData.name}.webp`;
	}
};

const getItemLabel = (item, itemData) => {
	const metadata = Boolean(item?.MetaData)
		? typeof item?.MetaData == 'string'
			? lua2json(item.MetaData)
			: item.MetaData
		: Object();

	if (metadata?.CustomItemLabel) {
		return metadata?.CustomItemLabel;
	} else {
		return itemData?.label ?? 'Unknown';
	}
};

export { getItemImage, getItemLabel };

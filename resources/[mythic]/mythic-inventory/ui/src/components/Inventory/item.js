const lua2json = (lua) =>
	JSON.parse(
		lua
			.replace(/\[([^\[\]]+)\]\s*=/g, (s, k) => `${k} :`)
			.replace(/,(\s*)\}/gm, (s, k) => `${k}}`),
	);

const getItemImage = (item, itemData) => {
	//console.log(item, itemData);
	if (item?.MetaData?.CustomItemImage) {
		return item?.MetaData?.CustomItemImage;
	} else if (Boolean(itemData) && Boolean(itemData.iconOverride)) {
		try {
			return require(`../../../images/items/${itemData.iconOverride}.webp`).default;
		} catch (error) {
			//console.log("Error 1");
			return null; 
		}
	} else {
		try {
			return require(`../../../images/items/${itemData?.name || item?.Name || item?.name}.webp`).default;
		} catch (error) {
			//console.log("Error", error);
			return null; 
			   
		}
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

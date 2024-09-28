import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import Nui from '../../util/Nui';
import useInterval from '../../util/useInterval';

export default ({ crafting }) => {
	const dispatch = useDispatch();
	const [ending, setEnding] = useState(false);

	useInterval(() => {
		if (Boolean(crafting) && !ending) {
			const dif = Date.now() - crafting.start;
			if (dif <= crafting.time + 100) {
				dispatch({
					type: 'CRAFT_PROGRESS',
					payload: {
						progress:
							((Date.now() - crafting.start) / crafting.time) *
							100,
					},
				});
			} else {
				setEnding(true);
				craftEnd();
			}
		}
	}, 250);

	useEffect(() => {
		if (!Boolean(crafting)) setEnding(false);
	}, [crafting]);

	const craftEnd = async () => {
		if (!Boolean(crafting)) return;
		setEnding(true)
		try {
			// console.log("Ending Crafting");
			Nui.send('Crafting:End', crafting.recipe)
		} catch (err) {}
	};

	return <></>;
};

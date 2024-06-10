import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { Slide } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Slot from './Slot';

const useStyles = makeStyles((theme) => ({
	slide: {
		position: 'absolute',
		bottom: 0,
		left: 0,
		width: '100%',
		display: 'flex',
		justifyContent: 'center',
	},
	wrapper: {
		margin: '1% auto',
		color: '#000000',
		width: '85%',
		display: 'flex',
	},
}));

export default connect()((props) => {
	const classes = useStyles();
	const hidden = useSelector((state) => state.app.showHotbar);
	const showing = useSelector((state) => state.app.showing);
	const items = useSelector((state) => state.inventory.items);
	const itemsLoaded = useSelector((state) => state.inventory.itemsLoaded);
	const playerInventory = useSelector((state) => state.inventory.player);

	const mode = useSelector((state) => state.app.mode);

	useEffect(() => {
		let tmr = null;
		if (hidden) {
			tmr = setTimeout(() => {
				props.dispatch({
					type: 'HOTBAR_HIDE',
				});
			}, 5000);

			return () => {
				clearTimeout(tmr);
			};
		}
	}, [hidden]);

	if (mode === 'crafting') {
		return null;
	}

	if (!itemsLoaded || Object.keys(items).length == 0) return null;
	return (
		<Slide direction="up" in={hidden} className={classes.slide}>
			<div className={classes.wrapper}>
				<div>
					{[...Array(4).keys()].map((value) => {
						return (
							<Slot
								inHotbar={true}
								showing={showing}
								key={value + 1}
								slot={value + 1}
								owner={playerInventory.owner}
								invType={playerInventory.invType}
								hotkeys={true}
								data={
									playerInventory.inventory[value + 1]
										? playerInventory.inventory[value + 1]
										: {}
								}
							/>
						);
					})}
				</div>
			</div>
		</Slide>
	);
});

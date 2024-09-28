import React, { Fragment, useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { Fade } from '@mui/material';
import { getItemImage, getItemLabel } from '../Inventory/item';

const useStyles = makeStyles((theme) => ({
	container: {
		pointerEvents: 'none',
		zIndex: 1,
	},
	img: {
		height: 125,
		width: '100%',
		overflow: 'hidden',
		zIndex: 3,
		backgroundSize: '100%',
		backgroundRepeat: 'no-repeat',
		backgroundPosition: 'center center',
	},
	label: {
		bottom: 0,
		left: 0,
		position: 'absolute',
		textAlign: 'center',
		padding: '0 5px',
		width: '100%',
		maxWidth: '100%',
		overflow: 'hidden',
		whiteSpace: 'nowrap',
		color: theme.palette.text.main,
		background: 'rgba(12,24,38, 0.733)',
		background: 'rgba(12,24,38, 0.733)',
		borderTop: `1px solid rgb(255 255 255 / 4%)`,
		zIndex: 4,
	},
	slot: {
		width: 125,
		height: 125,
		background: `rgba(12,24,38, 0.733)`,
		border: `1px solid rgba(255, 255, 255, 0.04)`,
		position: 'relative',
		zIndex: 2,
		// border: `1px solid ${theme.palette.border.divider}`,
		// '&.add': {
		// 	borderColor: theme.palette.success.main,
		// },
		// '&.removed': {
		// 	borderColor: theme.palette.error.main,
		// },
		// '&.used': {
		// 	borderColor: theme.palette.info.main,
		// },
	},
	count: {
		top: 0,
		right: 0,
		position: 'absolute',
		textAlign: 'right',
		padding: '0 5px',
		// textShadow: `0 0 5px ${theme.palette.secondary.dark}`,
		color: theme.palette.text.main,
		zIndex: 4,
	},
	type: {
		top: 0,
		left: 0,
		position: 'absolute',
		padding: '0 5px',
		color: theme.palette.text.main,
		background: 'rgba(12,24,38, 0.733)',
		borderRight: `1px solid ${theme.palette.border.divider}`,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		borderBottomRightRadius: 5,
		zIndex: 4,
	},
}));

export default ({ alert }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const itemData = useSelector((state) => state.inventory.items)[alert.item];

	const [show, setShow] = useState(true);

	useEffect(() => {
		let t = setTimeout(() => {
			setShow(false);
		}, 3000);

		return () => {
			clearTimeout(t);
		};
	}, []);

	const onAnimEnd = () => {
		dispatch({
			type: 'DISMISS_ALERT',
			payload: {
				id: alert.id,
			},
		});
	};

	const getTypeLabel = () => {
		switch (alert.type) {
			case 'add':
				return 'Added';
			case 'removed':
				return 'Removed';
			case 'used':
				return 'Used';
			default:
				return alert.type;
		}
	};

	return (
		<Fade in={show} onExited={onAnimEnd}>
			<div className={classes.container}>
				<div className={`${classes.slot} ${alert.type}`}>
					<div
						className={classes.img}
						style={{
							backgroundImage: `url(${getItemImage(
								alert.item,
								itemData,
							)})`,
						}}
					></div>
					{Boolean(itemData) && (
						<div className={classes.label}>
							{getItemLabel(alert.item, itemData)}
						</div>
					)}
					<div className={classes.type}>{getTypeLabel()}</div>
					{alert.count > 0 && (
						<div className={classes.count}>{alert.count}</div>
					)}
				</div>
			</div>
		</Fade>
	);
};

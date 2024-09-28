import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { closeInventory } from '../Inventory/actions';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	outsideDiv: {
		width: '100vw',
		height: '100vh',
		display: 'flex',
		justifyContent: 'center',
		alignItems: 'center',
		zIndex: -1,
		background: 'rgba(0,0,0,0.5)',
		'@global': {
			'*::-webkit-scrollbar': {
				width: 0,
			},
			'*::-webkit-scrollbar-thumb': {
				background: theme.palette.secondary.light,
			},
			'*::-webkit-scrollbar-thumb:hover': {
				background: theme.palette.primary.main,
			},
			'*::-webkit-scrollbar-track': {
				background: theme.palette.secondary.main,
			},
		},
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
	insideDiv: {
		width: '100%',
		height: '100%',
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
	dialog: {
		display: 'flex',
		flexDirection: 'column',
		margin: 'auto',
		width: 'fit-content',
		zIndex: -1,
	},
	closeButton: {
		position: 'absolute',
		top: 0,
		left: 0,
		color: theme.palette.primary.main,
		padding: 25,
		background: 'transparent',
		minWidth: 32,
		boxShadow: 'none',
		'&:hover': {
			color: theme.palette.primary.main,
			background: 'transparent',
			boxShadow: 'none',
			'& svg': {
				filter: 'brightness(0.8)',
				transition: 'filter ease-in 0.15s',
			},
		},
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const itemsLoaded = useSelector((state) => state.inventory.itemsLoaded);
	const hoverOrigin = useSelector((state) => state.inventory.hoverOrigin);

	const onClick = () => {
		if (Boolean(hoverOrigin)) {
			Nui.send('FrontEndSound', 'DISABLED');
			dispatch({
				type: 'SET_HOVER',
				payload: null,
			});
			dispatch({
				type: 'SET_HOVER_ORIGIN',
				payload: null,
			});
		}
	};

	const close = () => {
		dispatch({
			type: 'SET_CONTEXT_ITEM',
			payload: null,
		});
		dispatch({
			type: 'SET_SPLIT_ITEM',
			payload: null,
		});
		closeInventory();
	};
	
	return (
		<>
			{!props.hidden && itemsLoaded && (
				<div className={classes.outsideDiv} onClick={onClick}>
					<IconButton
						className={classes.closeButton}
						variant="contained"
						color="primary"
						onClick={close}
					>
						<FontAwesomeIcon icon={['fas', 'x']} />
					</IconButton>
					<div className={classes.insideDiv}>{props.children}</div>
				</div>
			)}
		</>
	);
};

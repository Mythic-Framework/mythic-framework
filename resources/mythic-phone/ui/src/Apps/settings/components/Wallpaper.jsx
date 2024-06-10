import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { Paper } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';

import { UpdateSetting } from '../actions';
import { useAlert } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		background: theme.palette.secondary.dark,
		width: '100%',
		height: 'fit-content',
		userSelect: 'none',
		border: `2px solid ${theme.palette.secondary.dark}`,
		padding: 10,
		textAlign: 'left',
		'-webkit-user-select': 'none',
		'&:hover': {
			background: theme.palette.secondary.light,
			borderColor: theme.palette.secondary.light,
			transition: 'background, border-color ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	wrapperActive: {
		background: theme.palette.secondary.dark,
		width: '100%',
		height: 'fit-content',
		userSelect: 'none',
		padding: 10,
		textAlign: 'left',
		border: `2px solid ${theme.palette.primary.main}`,
		'-webkit-user-select': 'none',
		'&:hover': {
			background: theme.palette.secondary.light,
			transition: 'background, border-color ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	img: {
		height: 200,
		width: '100%',
		display: 'block',
	},
}));

export default connect(null, { UpdateSetting })((props) => {
	const showAlert = useAlert();
	const classes = useStyles();
	const settings = useSelector((state) => state.data.data.player.PhoneSettings);

	const onClick = (e) => {
		e.preventDefault();
		props.UpdateSetting('wallpaper', props.item);
		showAlert('Wallpaper Updated');
	};

	useEffect(() => {
		if (settings.wallpaper === props.item) {
			const item = document.querySelector(`#${settings.wallpaper}`);
			if (item) {
				item.scrollIntoView({ block: 'end', behavior: 'smooth' });
			}
		}
	}, [settings.wallpaper]);

	return (
		<Paper
			className={
				settings.wallpaper === props.item
					? classes.wrapperActive
					: classes.wrapper
			}
			onClick={onClick}
			id={props.item}
		>
			<img
				className={classes.img}
				src={props.wallpaper.file}
				alt={props.wallpaper.label}
			/>
			{props.wallpaper.label}
		</Paper>
	);
});

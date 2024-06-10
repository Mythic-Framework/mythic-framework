import React from 'react';
import { connect, useSelector } from 'react-redux';
import { Grid } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';

import CustomColor from './components/CustomColor';
import Version from './components/Version';
import { UpdateSetting } from './actions';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		textAlign: 'center',
		padding: '0 2px',
	},
	colorsList: {
		height: '95%',
		overflowY: 'auto',
		overflowX: 'hidden',
		margin: '0 !important',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
}));

export default connect(null, { UpdateSetting })((props) => {
	const classes = useStyles();
	const settings = useSelector(
		(state) => state.data.data.player.PhoneSettings,
	);

	const onAccentSave = (hex) => {
		props.UpdateSetting('colors', {
			...settings.colors,
			accent: hex,
		});
	};

	return (
		<div className={classes.wrapper}>
			<Grid container className={classes.colorsList}>
				<Grid item xs={12}>
					<CustomColor
						label="Accent Color"
						color={
							Boolean(settings?.colors)
								? settings.colors.accent
								: '#dd1e36'
						}
						onSave={onAccentSave}
					/>
				</Grid>
			</Grid>
			<Version />
		</div>
	);
});

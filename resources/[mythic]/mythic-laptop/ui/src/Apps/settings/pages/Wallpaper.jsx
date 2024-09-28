import React from 'react';
import {
	Grid,
} from '@mui/material';
import { makeStyles, withStyles } from '@mui/styles';

import Wallpaper from '../components/Wallpaper';
import CustomWallpaper from '../components/CustomWallpaper';
//import Version from './components/Version';

import { Wallpapers } from '../../../util/Wallpapers';

const useStyles = makeStyles(theme => ({
	wrapper: {
		height: '93.25%',
		background: theme.palette.secondary.main,
		textAlign: 'center',
		padding: '0 2px',
	},
	wallpaperList: {
		maxHeight: '95%',
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

export default props => {
	const classes = useStyles();

	return (
		<div className={classes.wrapper}>
			<Grid container spacing={1} className={classes.wallpaperList}>
				<Grid item xs={3}>
					<CustomWallpaper />
				</Grid>
				{Object.keys(Wallpapers).map((item, index) => {
					return (
						<Grid key={`wallpaper-${index}`} item xs={3}>
							<Wallpaper
								item={item}
								wallpaper={Wallpapers[item]}
							/>
						</Grid>
					);
				})}
			</Grid>
			{/* <Version /> */}
		</div>
	);
};

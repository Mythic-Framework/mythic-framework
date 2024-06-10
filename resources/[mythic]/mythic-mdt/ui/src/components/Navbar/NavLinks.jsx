import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { useMediaQuery, List } from '@mui/material';
import { useTheme } from '@mui/material/styles';

import MenuItem from './MenuItem';
import MenuItemSub from './MenuItemSub';
import { usePermissions } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	mainNav: {
		borderRight: `1px solid ${theme.palette.border.divider}`,
		background: theme.palette.secondary.main,
		width: '100%',
		display: 'inline-block',
		verticalAlign: 'top',
		height: '100%',
		overflow: 'auto',
		'&::-webkit-scrollbar': {
			width: 0,
		},
	},
	menu: {
		background: theme.palette.secondary.dark,
		borderRadius: 0,
		zIndex: 100,
	},
}));

export default (props) => {
	const classes = useStyles();
	const theme = useTheme();
	const hasPerm = usePermissions();
	const user = useSelector((state) => state.app.user);
	const isMobile = !useMediaQuery(theme.breakpoints.up('lg'));

	return (
		<List className={!isMobile ? classes.mainNav : ''}>
			{props.links.map((link, i) => {
				if (
					link.restrict &&
					(!Boolean(user) || !hasPerm(link.restrict.permission))
				)
					return null;
				if (Boolean(link.items) && link.items.length > 0) {
					return (
						<div key={`${link.path}-${i}`}>
							<MenuItemSub
								compress={props.compress}
								link={link}
								open={props.open}
								onClick={props.onClick}
								handleMenuClose={props.handleMenuClose}
							/>
						</div>
					);
				} else {
					return (
						<div key={`${link.path}-${i}`}>
							<MenuItem
								compress={props.compress}
								link={link}
								onClick={props.handleMenuClose}
							/>
						</div>
					);
				}
			})}
		</List>
	);
};

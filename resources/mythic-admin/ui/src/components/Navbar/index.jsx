import React, { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { useMediaQuery, Drawer } from '@material-ui/core';
import { useTheme } from '@material-ui/core/styles';
import { useLocation } from 'react-router-dom';

import NavLinksEl from './NavLinks';

const useStyles = makeStyles((theme) => ({
	root: {
		flexGrow: 1,
		background: theme.palette.secondary.dark,
		width: '100%',
		height: 86,
		zIndex: 100,
	},
	cityLogo: {
		width: 80,
		padding: 10,
	},
	cityLogoLink: {
		background: theme.palette.secondary.main,
		'&:hover': {
			background: theme.palette.secondary.light,
			transition: 'background ease-in 0.15s',
		},
	},
	branding: {
		marginLeft: 10,
		marginRight: 10,
		fontSize: 22,
		'& small': {
			display: 'block',
			fontSize: 14,
			color: theme.palette.text.alt,
		},
	},
	navLinks: {
		display: 'inline-flex',
		alignItems: 'center',
		width: '100%',
	},
	mobileNav: {
		width: '100%',
		maxWidth: 360,
		backgroundColor: theme.palette.secondary.dark,
	},
	navbar: {
		backgroundColor: theme.palette.secondary.main,
		position: 'absolute !important',
		width: '100%',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
	},
	menuButton: {
		display: 'inline',
		color: theme.palette.text.main,
		fontSize: 18,
		padding: '0 10px',
		lineHeight: '18px',
		textDecoration: 'none',
		borderRadius: 5,
		'&:first-child': {
			marginLeft: 0,
		},
		'&:last-child': {
			marginRight: 0,
		},
		'& svg': {
			color: theme.palette.alt.green,
			fontSize: 12,
			height: 21,
			lineHeight: '50px',
			width: '30px !important',
			textAlign: 'center',
			position: 'relative',
			top: 1,
			transition: 'all ease 0.4s',
		},
		'&:hover': {
			color: `${theme.palette.primary.main}91`,
			transition: 'color ease-in 0.15s',
			cursor: 'pointer',
			'& svg': {
				color: `${theme.palette.primary.main}91`,
				transition: 'color ease-in 0.15s',
			},
		},
		'&.active': {
			color: theme.palette.primary.main,
			'& svg': {
				color: theme.palette.primary.main,
				'--fa-secondary-opacity': 1.0,
			},
		},
	},
	title: {
		flexGrow: 1,
	},
	right: {
		display: 'inline-flex',
		alignItems: 'center',
		marginRight: 10,
	},
	user: {
		marginRight: 10,
		textAlign: 'right',
		'& small': {
			display: 'block',
			color: theme.palette.text.alt,
		},
	},
}));

export default ({ links }) => {
	const classes = useStyles();
	const theme = useTheme();
	const isMobile = !useMediaQuery(theme.breakpoints.up('lg'));
	const job = useSelector(state => state.app.govJob);
	const [mobileOpen, setMobileOpen] = useState(false);

	useEffect(() => {
		if (!isMobile) {
			setMobileOpen(false);
		}
	}, [isMobile]);

	const usable = job?.Id === 'police';

	const [open, setOpen] = useState(false);
	const onClick = (e) => {
		e.preventDefault();
		if (e.currentTarget.name === open) {
			setOpen(false);
		} else {
			setOpen(e.currentTarget.name);
		}
	};

	const handleMenuClose = () => {
		if (!usable) return;
		setMobileOpen(false);
	};

	const [compress, setCompress] = useState(false);

	return (
		<>
			{!isMobile ? (
				<NavLinksEl
					links={links}
					onClick={onClick}
					handleMenuClose={handleMenuClose}
					open={open}
					compress={compress}
				/>
			) : null}

			<Drawer
				PaperProps={{ className: classes.mobileNav }}
				anchor="left"
				open={mobileOpen && isMobile}
				onClose={() => setMobileOpen(false)}
			>
				<NavLinksEl
					links={links}
					onClick={onClick}
					handleMenuClose={handleMenuClose}
					open={open}
					compress={false}
				/>
			</Drawer>
		</>
	);
};

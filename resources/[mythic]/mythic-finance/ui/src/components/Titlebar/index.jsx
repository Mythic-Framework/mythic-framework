import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { AppBar, Toolbar, IconButton, Divider, Grid } from '@material-ui/core';
import { NavLink, Link } from 'react-router-dom';

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Fleeca from '../../assets/img/fleeca.png';
import Maze from '../../assets/img/maze.png';
import BlaineCo from '../../assets/img/blaineco.png';
import UnionDepo from '../../assets/img/ud.png';

import Nui from '../../util/Nui';
import { CurrencyFormat } from '../../util/Parser';

const useStyles = makeStyles((theme) => ({
	root: {
		flexGrow: 1,
		background: theme.palette.secondary.dark,
		width: '100%',
		height: 86,
		zIndex: 100,
	},
	bankLogoLink: {
		background: theme.palette.secondary.main,
		'&:hover': {
			background: theme.palette.secondary.light,
			transition: 'background ease-in 0.15s',
		},
	},
	bankLogo: {
		width: '100%',
		maxWidth: 298,
		padding: 4,
	},
	tb: {
		minHeight: 125,
		position: 'relative',
	},
	navLinks: {
		display: 'inline-flex',
		alignItems: 'center',
		width: '100%',
		height: 'fit-content',
		top: 0,
		bottom: 0,
		margin: 'auto',
	},
	navbar: {
		backgroundColor: theme.palette.secondary.main,
		width: '100%',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
	},
	right: {
		display: 'inline-flex',
		alignItems: 'center',
		marginRight: 10,
		position: 'absolute',
		right: 0,
	},
	user: {
		textAlign: 'right',
		fontSize: 18,
		fontWeight: 'regular',
		'& small': {
			'&::before': {
				content: '", "',
				color: theme.palette.text.alt,
			},
			color: theme.palette.primary.main,
			marginRight: 10,

			'& b': {
				color: theme.palette.text.main,
			},
		},
	},
	money: {
		display: 'block',
		fontSize: 14,
		marginRight: 10,
		color: theme.palette.success.main,
		'&::before': {
			content: '"Cash:"',
			marginRight: 5,
			color: theme.palette.text.alt,
		},
	},
	navLinkContainer: {
		display: 'inline-flex',
		alignItems: 'center',
	},
	navLink: {
		fontSize: 16,
		color: theme.palette.text.alt,
		transition: 'color ease-in 0.15s',
		'&:hover': {
			color: theme.palette.primary.dark,
		},
		'&.active': {
			color: theme.palette.primary.main,
		},
		'&:not(:last-of-type)': {
			marginRight: 20,
		},
	},
}));

export default () => {
	const classes = useStyles();
	const brand = useSelector((state) => state.app.brand);
	const app = useSelector((state) => state.app.app);
	const user = useSelector((state) => state.data.data.character);

	const getBranding = () => {
		switch (brand) {
			case 'fleeca':
				return Fleeca;
			case 'maze':
				return Maze;
			case 'blaineco':
				return BlaineCo;
			case 'ud':
				return UnionDepo;
			default:
				return Fleeca;
		}
	};

	const onClose = () => {
		Nui.send('Close');
	};

	const getNavLinks = () => {
		switch (app) {
			case 'BANK':
				return [
					{
						link: '/',
						label: 'My Accounts',
						isExact: true,
					},
					// {
					// 	link: '/loans',
					// 	label: 'My Loans',
					// 	isExact: false,
					// },
					// {
					// 	link: '/credit',
					// 	label: 'My Credit',
					// 	isExact: true,
					// },
				];
			case 'ATM':
				return [];
		}
	};

	return (
		<AppBar
			elevation={0}
			position="relative"
			color="secondary"
			className={classes.navbar}
		>
			<Toolbar className={classes.tb} disableGutters>
				<div className={classes.navLinks}>
					<Link to="/" className={classes.bankLogoLink}>
						<img src={getBranding()} className={classes.bankLogo} />
					</Link>
					{getNavLinks().length > 0 && (
						<>
							<Divider orientation="vertical" flexItem />
							<div style={{ marginLeft: 20, lineHeight: '20px' }}>
								{getNavLinks().map((link, k) => {
									return (
										<NavLink
											key={`link-${k}`}
											className={classes.navLink}
											to={link.link}
											exact={link.isExact}
										>
											{link.label}
										</NavLink>
									);
								})}
							</div>
						</>
					)}
				</div>
				<div className={classes.right}>
					<div className={classes.user}>
						Welcome
						<small>{`${user.First} ${user.Last}`}</small>
						<span className={classes.money}>
							{CurrencyFormat.format(user.Cash)}
						</span>
					</div>
					<Divider orientation="vertical" flexItem />
					<IconButton onClick={onClose}>
						<FontAwesomeIcon icon={['fas', 'xmark']} />
					</IconButton>
				</div>
			</Toolbar>
		</AppBar>
	);
};

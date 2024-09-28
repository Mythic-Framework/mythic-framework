import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { AppBar, Toolbar, IconButton, Divider } from '@mui/material';
import { Link, useNavigate, useLocation } from 'react-router-dom';

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useBranding, useCitySeal } from '../../hooks';
import Nui from '../../util/Nui';
import Account from './Account';

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
		padding: 4,
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
	navbar: {
		backgroundColor: theme.palette.secondary.main,
		width: '100%',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
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
	callsign: {
		fontSize: 14,
		color: theme.palette.primary.main,
	},
}));

export default ({ businessData }) => {
	const classes = useStyles();
	const history = useNavigate();
	const location = useLocation();
	const dispatch = useDispatch();
	const getSeal = useCitySeal();
	const job = useSelector((state) => state.app.govJob);
	const attorney = useSelector((state) => state.app.attorney);
	const hidden = useSelector((state) => state.app.hidden);

	const branding = useBranding(job, attorney);


	const onClose = () => {
		Nui.send('Close');
	};

	const hoverChange = (state) => {
		if (!hidden && !location.pathname.startsWith('/admin') && !location.pathname.startsWith('/system')) {
			dispatch({
				type: 'SET_OPACITY_MODE',
				payload: {
					state,
				},
			});
		}
	};

	return (
		<AppBar elevation={0} position="relative" color="secondary" className={classes.navbar}>
			<Toolbar disableGutters>
				<div
					className={classes.title}
					onMouseEnter={() => hoverChange(true)}
					onMouseLeave={() => hoverChange(false)}
				>
					<div className={classes.navLinks}>
						<Link to="/" className={classes.cityLogoLink}>
							<img src={getSeal()} className={classes.cityLogo} />
						</Link>
						<Divider orientation="vertical" flexItem />
						<div className={classes.branding}>
							<span>
								{branding.primary}
								<small>{branding.secondary}</small>
							</span>
						</div>
					</div>
				</div>
				<div className={classes.right}>
					<div className={classes.user}>
						<Account />
					</div>
					<Divider orientation="vertical" flexItem />
					<IconButton onClick={() => history(-1)}>
						<FontAwesomeIcon icon={['fas', 'chevron-left']} />
					</IconButton>
					<IconButton onClick={() => history(1)}>
						<FontAwesomeIcon icon={['fas', 'chevron-right']} />
					</IconButton>
					<IconButton onClick={onClose}>
						<FontAwesomeIcon icon={['fas', 'xmark']} />
					</IconButton>
				</div>
			</Toolbar>
		</AppBar>
	);
};

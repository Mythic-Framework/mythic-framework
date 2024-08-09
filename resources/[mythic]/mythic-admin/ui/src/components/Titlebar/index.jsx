import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { AppBar, Toolbar, IconButton, Divider } from '@material-ui/core';
import { Link, useHistory, useLocation } from 'react-router-dom';

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Logo from '../../assets/img/logo.png';

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
	logo: {
		width: 100,
		padding: 4,
	},
	logoLink: {
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

export default () => {
	const classes = useStyles();
	const history = useHistory();
	const location = useLocation();
	const dispatch = useDispatch();

	const hidden = useSelector(state => state.app.hidden);
	const user = useSelector(state => state.app.user);
	const permissionLevel = useSelector(state => state.app.permissionLevel);

	const onClose = () => {
		Nui.send('Close');
	};

	const onDetach = () => {
		Nui.send('StopAllAttach')
	};

	const viewSelf = () => {
		history.push(`/player/${user?.Source}`);
	};

	const goInvisible = () => {
		Nui.send('ToggleInvisible');
	};

	const toggleIds = () => {
		Nui.send('ToggleIDs');
	};

	const hoverChange = (state) => {
		if (!hidden) {
			dispatch({
				type: 'SET_OPACITY_MODE',
				payload: {
					state,
				},
			});
		}
	};

	return (
		<AppBar
			elevation={0}
			position="relative"
			color="secondary"
			className={classes.navbar}
		>
			<Toolbar disableGutters>
				<div 
					className={classes.title}
					onMouseEnter={() => hoverChange(true)}
        			onMouseLeave={() => hoverChange(false)}
				>
					<div className={classes.navLinks}>
						<Link to="/" className={classes.logoLink}>
							<img src={Logo} className={classes.logo} />
						</Link>
						<Divider orientation="vertical" flexItem />
						<div className={classes.branding}>
							<span>Admin System</span>
						</div>
					</div>
				</div>
				<div className={classes.right}>
					<div className={classes.user}>
						<Account />
					</div>
					<Divider orientation="vertical" flexItem />
					{permissionLevel >= 100 && <IconButton onClick={goInvisible}>
						<FontAwesomeIcon icon={['fas', 'eye-slash']} />
					</IconButton>}
					<IconButton onClick={toggleIds}>
						<FontAwesomeIcon icon={['fas', 'id-badge']} />
					</IconButton>
					<IconButton onClick={viewSelf}>
						<FontAwesomeIcon icon={['fas', 'user-large']} />
					</IconButton>
					<IconButton onClick={onDetach}>
						<FontAwesomeIcon icon={['fas', 'link-slash']} />
					</IconButton>
					<IconButton onClick={history.goBack}>
						<FontAwesomeIcon icon={['fas', 'chevron-left']} />
					</IconButton>
					<IconButton onClick={history.goForward}>
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

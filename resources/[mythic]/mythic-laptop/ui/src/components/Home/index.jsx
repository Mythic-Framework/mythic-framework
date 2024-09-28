import React, { useEffect, useState } from 'react';
import { connect, useDispatch, useSelector } from 'react-redux';
import { Menu, MenuItem, Avatar, Badge } from '@mui/material';
import { makeStyles, withStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
//import NestedMenuItem from 'material-ui-nested-menu-item';

import {
	useAlert,
	useAppView,
	useAppButton,
	useReorder,
	useMyApps,
} from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		userSelect: 'none',
		zIndex: 0,
	},
	grid: {
		display: 'flex',
		flexFlow: 'column',
		height: '87.5%',
		padding: 10,
		flexWrap: 'wrap',
		justifyContent: 'start',
		alignContent: 'flex-start',
		overflowX: 'hidden',
		overflowY: 'auto',
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
	appBtn: {
		height: 100,
		width: 85,
		display: 'inline-block',
		textAlign: 'center',
		height: 'fit-content',
		padding: 10,
		borderRadius: 10,
		position: 'relative',
		zIndex: 5,
		'&:hover:not(.fake)': {
			transition: 'background ease-in 0.15s',
			background: `${theme.palette.primary.main}40`,
			cursor: 'pointer',
		},
	},
	appIcon: {
		fontSize: 30,
		width: 50,
		height: 50,
		margin: 'auto',
		color: '#fff',
	},
	appLabel: {
		fontSize: 12,
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		textShadow: '0px 0px 5px #000000',
		fontWeight: 'normal',
		marginTop: 10,
		pointerEvents: 'none',
	},
}));

const NotifCount = withStyles((theme) => ({
	root: {
		width: 24,
		height: 24,
		fontSize: 16,
		lineHeight: '24px',
		color: '#fff',
		background: '#ff0000',
	},
}))(Avatar);

export default (props) => {
	const openedApp = useAppView();
	const classes = useStyles();
	const dispatch = useDispatch();
	const apps = useMyApps();

	const homeApps = useSelector((state) => state.data.data.player?.LaptopApps?.home);

	useEffect(() => {
		dispatch({
			type: 'NOTIF_RESET_APP',
		});
	}, []);

	const onClick = (e, app) => {
		e.preventDefault();

		if (!apps?.[app]?.fake) {
			openedApp(app);
		}
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.grid}>
				{Object.keys(apps).length > 0
					? homeApps.map((app, i) => {
							let data = apps[app];
							if (data) {
								return (
									<div
										key={i}
										className={`${classes.appBtn} ${data.fake ? 'fake' : null}`}
										title={data.label}
										onClick={(e) => onClick(e, app)}
									>
										{data.unread > 0 ? (
											<Badge
												overlap="circle"
												anchorOrigin={{
													vertical: 'bottom',
													horizontal: 'right',
												}}
												badgeContent={
													<NotifCount
														style={{
															border: `2px solid ${data.color}`,
														}}
													>
														{data.unread}
													</NotifCount>
												}
											>
												<Avatar
													variant="rounded"
													className={classes.appIcon}
													style={{
														background: `${data.color}`,
													}}
												>
													<FontAwesomeIcon
														icon={data.icon}
													/>
												</Avatar>
											</Badge>
										) : (
											<Avatar
												variant="rounded"
												className={classes.appIcon}
												style={{
													background: `${data.color}`,
												}}
											>
												<FontAwesomeIcon
													icon={data.icon}
												/>
											</Avatar>
										)}
										<div className={classes.appLabel}>
											{data.label}
										</div>
									</div>
								);
							} else return null;
					  })
					: null}
			</div>
		</div>
	);
};

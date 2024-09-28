import React, { useRef } from 'react';
import { Grid, Button } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Draggable from 'react-draggable'; // The default
import { useDispatch, useSelector } from 'react-redux';

export default ({
	title,
	children,
	app,
	appState,
	appData,
	onRefresh = null,
	color = false,
	width = '100%',
	height = '100%',
}) => {
	const dispatch = useDispatch();
	const focused = useSelector((state) => state.apps.focused);
	const useStyles = makeStyles((theme) => ({
		window: {
			maxHeight:
				appState.maximized || !Boolean(appData.size) ? '100%' : height,
			maxWidth:
				appState.maximized || !Boolean(appData.size) ? '100%' : width,
			height: '100%',
			width: '100%',
			position: 'absolute',
			zIndex: focused == app ? 200 : 100,
			border: !Boolean(appData.size)
				? 'none'
				: `2px solid ${
						focused == app
							? appData.color
							: theme.palette.secondary.main
				  }`,
		},
		titlebar: {
			height: 50,
			width: '100%',
			background:
				focused == app
					? Boolean(color)
						? color
						: theme.palette.primary.main
					: theme.palette.secondary.light,
			lineHeight: '50px',
			display: 'flex',
			userSelect: 'none',
			zIndex: focused == app ? 200 : 100,
		},
		title: {
			display: 'inline-block',
			flex: 1,
			paddingLeft: 15,
		},
		actions: {
			display: 'inline-block',
			textAlign: 'center',
		},
		action: {
			height: 50,
			width: 60,
			color: theme.palette.text.main,
		},
		content: {
			height: 'calc(100% - 50px)',
			background: theme.palette.secondary.dark,
		},
		windowDrag: {
			visibility: appState.minimized ? 'hidden' : 'normal',
		},
	}));

	const classes = useStyles();

	const onStart = () => {
		if (focused != app) {
			dispatch({
				type: 'UPDATE_FOCUS',
				payload: {
					app,
				},
			});
		}
	};

	const onClick = () => {
		if (focused != app) {
			dispatch({
				type: 'UPDATE_FOCUS',
				payload: {
					app,
				},
			});
		}
	};

	const onMinimize = () => {
		dispatch({
			type: 'MINIMIZE_APP',
			payload: {
				app,
			},
		});
	};

	const onClose = () => {
		dispatch({
			type: 'CLOSE_APP',
			payload: {
				app,
			},
		});
	};

	return (
		<Draggable
			bounds="parent"
			defaultClassName={classes.windowDrag}
			handle={`.${classes.titlebar}`}
			defaultPosition={{ x: 0, y: 0 }}
			disabled={width == '100%' && height == '100%'}
			onStart={onStart}
		>
			<div className={classes.window} onClick={onClick}>
				<div className={classes.titlebar}>
					<div className={classes.title}>{title}</div>
					<div className={classes.actions}>
						{Boolean(onRefresh) && (
							<Button fullWidth className={classes.action}>
								<FontAwesomeIcon
									icon={['fas', 'arrows-rotate']}
								/>
							</Button>
						)}
						<Button
							fullWidth
							className={classes.action}
							onClick={onMinimize}
						>
							<FontAwesomeIcon icon={['fas', 'minus']} />
						</Button>
						<Button
							fullWidth
							className={classes.action}
							onClick={onClose}
						>
							<FontAwesomeIcon icon={['fas', 'x']} />
						</Button>
					</div>
				</div>
				<div className={classes.content}>{children}</div>
			</div>
		</Draggable>
	);
};

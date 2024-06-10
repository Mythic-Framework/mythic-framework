import React, { useState } from 'react';
import { LinearProgress, Grid } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { useSelector } from 'react-redux';
//import ReactPlayer from 'react-player';
import Logo from './Logo';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import bg from '../../bg.jpg';

const useStyles = makeStyles((theme) => ({
	background: {
		backgroundColor: theme.palette.secondary.dark,
		backgroundSize: 'cover',
		minHeight: '100vh',
		display: 'flex',
		overflow: 'hidden',
		justifyContent: 'center',
		alignItems: 'center',
	},
	backgroundImage: {
		//height: '100vh',
		width: '100vw',
	},
	particles: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		zIndex: 9,
	},
	logo: {
		position: 'absolute',
		width: 'fit-content',
		height: 'fit-content',
		textAlign: 'center',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		zIndex: 10,
		pointerEvents: 'none',
	},
	logoImg: {
		width: '30%',
	},
	text: {
		color: theme.palette.text.main,
		fontSize: '3em',
		textShadow: '2px 2px 8px rgba(0, 0, 0, 0.5)',
		fontFamily: 'Oswald',
		marginTop: 25,
	},
	hightlight: {
		color: theme.palette.primary.main,
	},
	prog: {
		display: 'block',
		width: '100%',
		position: 'absolute',
		bottom: 0,
		left: 0,
	},
	effect: {
		position: 'absolute',
		width: '100%',
		height: '100%',
	},
	bar: {
		height: 10,
	},
	dot1: {
		color: theme.palette.primary.main,
	},
	dot2: {
		color: theme.palette.text.main,
	},
	dot3: {
		color: theme.palette.primary.main,
	},
	domain: {
		position: 'absolute',
		top: '1%',
		right: '1%',
		fontFamily: 'Oswald',
		fontSize: 13,
		'& svg': {
			marginLeft: 10,
		},
	},
	discord: {
		position: 'absolute',
		top: '1%',
		left: '1%',
		fontFamily: 'Oswald',
		fontSize: 13,
		'& svg': {
			marginRight: 10,
		},
	},
	information: {
		position: 'absolute',
		bottom: '5.5%',
		right: '1%',
		maxWidth: '25%',
		background: theme.palette.secondary.main,
		padding: 10,
		border: `1px solid ${theme.palette.primary.dark}`,
		borderRadius: 5,
	},
	informationTitle: {
		fontSize: 18,
		color: theme.palette.primary.main,
	},
	informationMessage: {
		padding: 10,
		fontSize: 14,
		color: theme.palette.text.alt,
		whiteSpace: 'pre-wrap',
	},
	stageText: {
		position: 'absolute',
		left: '1%',
		bottom: '300%',
	},
	completedStage: {
		color: '#ffffff',
		fontWeight: 'bold',
		fontSize: 20,
		fontFamily: 'Oswald',
		'&::after': {
			color: theme.palette.primary.main,
			content: '": COMPLETED,"',
			marginRight: 24,
		},
	},
	currentStage: {
		color: '#ffffff',
		fontWeight: 'bold',
		fontSize: 20,
		fontFamily: 'Oswald',
		'&::after': {
			color: theme.palette.primary.main,
			content: '": IN PROGRESS,"',
			marginRight: 24,
		},
	},
	img: {},
	innerBody: {
		lineHeight: '250%',
		transform: 'translate(0%, 50%)',
	},
	splashHeader: {
		fontSize: '2vw',
		display: 'block',
	},
	splashBranding: {
		color: theme.palette.primary.main,
	},
	splashTip: {
		fontSize: '1vw',
		animation: '$blinker 1s linear infinite',
	},
	splashTipHighlight: {
		fontWeight: 500,
		color: theme.palette.primary.main,
		opacity: 1,
	},
	'@keyframes blinker': {
		'50%': {
			opacity: 0.3,
		},
	},
}));

export default () => {
	const classes = useStyles();

	const test = useSelector((state) => state.load.test);
	const pct = Math.min(test.current / test.total) * 100;
	const completed = useSelector((state) => state.load.completed);
	const current = useSelector((state) => state.load.currentStage);

	const name = useSelector(state => state.load.name);
	const priority = useSelector(state => state.load.priority);
	const priorityMessage = useSelector(state => state.load.priorityMessage);

	return (
		<div className={classes.background}>
			<Logo name={name} />
			<div className={classes.domain}>
				<FontAwesomeIcon icon={['fas', 'rocket-launch']} />
			</div>
			<div className={classes.discord}>
				<FontAwesomeIcon icon={['fab', 'discord']} /> 
			</div>
			{
				(priority > 0 && priorityMessage) && (
					<div className={classes.information}>
						<div className={classes.informationTitle}>
							Total Priority Boosts: <b>{priority}</b>
						</div>
						<div className={classes.informationMessage}>{priorityMessage}</div>
					</div>
				)
			}
			<div className={classes.prog}>
				<div className={classes.stageText}>
					{Object.keys(completed).map((val) => {
						return (
							<span className={classes.completedStage}>
								{val}
							</span>
						);
					})}
					{current != null ? (
						<span className={classes.currentStage}>{current}</span>
					) : pct >= 100 ? (
						<span className={classes.currentStage}>
							LOAD_MODELS
						</span>
					) : null}
				</div>
				<LinearProgress
					className={classes.bar}
					variant="determinate"
					value={pct <= 100 ? pct : 100}
				/>
			</div>
			<img className={classes.backgroundImage} src={bg} />
			{/* <ReactPlayer
				url="https://media.alzar.dev/loadscreen.webm"
				width="100vw"
				height="100%"
				controls={false}
				loop
				playing
				muted
			/> */}
		</div>
	);
};

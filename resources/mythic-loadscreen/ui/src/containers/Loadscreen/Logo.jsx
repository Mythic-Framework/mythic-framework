import React from 'react';
import { CircularProgress } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { Dot } from 'react-animated-dots';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		width: '55%',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		textAlign: 'center',
		fontSize: 30,
		color: theme.palette.text.main,
		zIndex: 1000,
		padding: 36,
		display: 'flex',
		flexDirection: 'column',
		justifyContent: 'flex-end',
	},
	img: {
		maxWidth: 900,
		width: '100%',
	},
	innerBody: {
		marginBottom: '100px',
		lineHeight: '250%',
		transform: 'translate(0%, 50%)',
		width: '100%',
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
	dot1: {
		color: theme.palette.primary.main,
	},
	dot2: {
		color: theme.palette.text.main,
	},
	dot3: {
		color: theme.palette.primary.main,
	},
	'@keyframes blinker': {
		'50%': {
			opacity: 0.3,
		},
	},
}));

export default (props) => {
	const classes = useStyles();

	return (
		<div className={classes.wrapper}>
			{/* <img className={classes.img} src={logo} /> */}
			<div className={classes.innerBody}>
				<span className={classes.splashHeader}>
					{
						props.name && (
							<b>
								{props.name},{' '} 
							</b>
						)
					}
					Welcome To Mythic RP
				</span>
				<span className={classes.splashTip}>
					{`Loading Into Server `}
					<Dot className={classes.dot1}>.</Dot>
					<Dot className={classes.dot2}>.</Dot>
					<Dot className={classes.dot3}>.</Dot>
				</span>
			</div>
		</div>
	);
};

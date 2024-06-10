import React from 'react';
import { ButtonGroup, Button } from '@mui/material';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
	modal: {
		height: 'fit-content',
		width: '80%',
		position: 'absolute',
		bottom: '15%',
		right: 0,
		left: 0,
		margin: 'auto',
		background: theme.palette.secondary.dark,
		boxShadow: '0 0 15px #000000',
		textAlign: 'center',
		borderRadius: 30,
		zIndex: 10003,
	},
	header: {
		paddingBottom: 10,
		fontSize: 25,
		color: theme.palette.text.main,
	},
	body: {
		padding: 5,
		color: theme.palette.text.main,
	},
	footer: {
		fontSize: 20,
		fontWeight: 'bold',
		color: theme.palette.primary.main,
		width: '100%',
	},
	footerButton: {
		padding: 20,
		borderBottomLeftRadius: 30,
		width: '-webkit-fill-available',
	},
	background: {
		position: 'absolute',
		right: 30,
		bottom: 95,
		height: 870,
		width: 440,
		background: '#000',
		opacity: 0.75,
		zIndex: 10002,
		borderRadius: 25,
	},
	backgroundInner: {
		display: 'block',
		height: '100%',
		width: '100%',
		background: 'rgba(0, 0, 0, 0.75)',
		borderRadius: 50,
	},
}));

export default (props) => {
	const classes = useStyles();

	if (props.open != null && !!props.open) {
		return (
			<div>
				<div className={classes.background}>
					<div
						className={classes.backgroundInner}
						onClick={props.onDecline}
					></div>
				</div>
				<div className={classes.modal}>
					<h2 className={classes.header}>{props.title}</h2>
					<div className={classes.body}>{props.children}</div>
					<div className={classes.footer}>
						<ButtonGroup
							variant="text"
							color="primary"
							className={classes.footer}
						>
							<Button
								className={classes.footerButton}
								onClick={props.onDecline}
							>
								{props.decline}
							</Button>
							<Button
								className={classes.footerButton}
								onClick={props.onConfirm}
							>
								{props.confirm}
							</Button>
						</ButtonGroup>
					</div>
				</div>
			</div>
		);
	} else {
		return null;
	}
};

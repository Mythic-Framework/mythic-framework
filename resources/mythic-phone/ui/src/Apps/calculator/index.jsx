import React, { useState, useEffect } from 'react';
import { makeStyles } from '@material-ui/styles';
import { Button, Grid } from '@material-ui/core';
import mexp from 'math-expression-evaluator';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		padding: 15,
	},
	content: {
		width: '100%',
		height: '100%',
		margin: 'auto',
		padding: 10,
		background: theme.palette.secondary.dark,
		border: `1px solid ${theme.palette.border.divider}`,
		fontSize: 30,
		wordBreak: 'break-word',
		overflowWrap: 'break-word',
		fontFamily: 'monospace',
	},
	button: {
		height: '100%',
		fontSize: 35,
	}
}));

export default (props) => {
	const classes = useStyles();

	const [mathString, setMathString] = useState('');
	const allowedKeys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '=', '+', '-', '/', '*', 'Backspace', 'Enter'];

	useEffect(() => {
		const Cunt = (e) => {
			if (allowedKeys.includes(e.key)) {
				onButtonPress(e.key);
			}
		};

		window.addEventListener('keydown', Cunt);
		return () => {
			window.removeEventListener('keydown', Cunt);
		};
	});

	const onButtonPress = (key) => {
		switch(key) {
			case 'reset':
				setMathString('');
				break;
			case 'Backspace':
			case 'del':
				setMathString(mathString.substring(0, mathString.length - 1));
				break;
			case 'Enter':
			case '=':
				try {
					const res = mexp.eval(mathString);
					if (!isNaN(res)) {
						setMathString(res.toString());
					} else {
						setMathString('Math Error');
					}
				} catch(e) {
					setMathString('Math Error');
				}
				break;
			default:
				setMathString(mathString + key.toString());
		}
	};

	return (
		<div className={classes.wrapper}>
			<Grid container spacing={2} style={{ height: '100%' }}>
				<Grid item xs={12} style={{ height: '30%' }}>
					<div className={classes.content}>
						{mathString.replace(/\*/g, '×').replace(/\//g, '÷')}
					</div>
				</Grid>
				<Grid item xs={3}>
					<Button className={classes.button} fullWidth variant="contained" color="primary" onClick={() => onButtonPress(7)}>
						7
					</Button>
				</Grid>
				<Grid item xs={3}>
					<Button className={classes.button} fullWidth variant="contained" color="primary" onClick={() => onButtonPress(8)}>
						8
					</Button>
				</Grid>
				<Grid item xs={3}>
					<Button className={classes.button} fullWidth variant="contained" color="primary" onClick={() => onButtonPress(9)}>
						9
					</Button>
				</Grid>
				<Grid item xs={3}>
					<Button className={classes.button} fullWidth variant="contained" color="secondary" onClick={() => onButtonPress('del')}>
						Del
					</Button>
				</Grid>
				<Grid item xs={3}>
					<Button className={classes.button} fullWidth variant="contained" color="primary" onClick={() => onButtonPress(4)}>
						4
					</Button>
				</Grid>
				<Grid item xs={3}>
					<Button className={classes.button} fullWidth variant="contained" color="primary" onClick={() => onButtonPress(5)}>
						5
					</Button>
				</Grid>
				<Grid item xs={3}>
					<Button className={classes.button} fullWidth variant="contained" color="primary" onClick={() => onButtonPress(6)}>
						6
					</Button>
				</Grid>
				<Grid item xs={3}>
					<Button className={classes.button} fullWidth variant="contained" color="secondary" onClick={() => onButtonPress('+')}>
						+
					</Button>
				</Grid>
				<Grid item xs={3}>
					<Button className={classes.button} fullWidth variant="contained" color="primary" onClick={() => onButtonPress(1)}>
						1
					</Button>
				</Grid>
				<Grid item xs={3}>
					<Button className={classes.button} fullWidth variant="contained" color="primary" onClick={() => onButtonPress(2)}>
						2
					</Button>
				</Grid>
				<Grid item xs={3}>
					<Button className={classes.button} fullWidth variant="contained" color="primary" onClick={() => onButtonPress(3)}>
						3
					</Button>
				</Grid>
				<Grid item xs={3}>
					<Button className={classes.button} fullWidth variant="contained" color="secondary" onClick={() => onButtonPress('-')}>
						-
					</Button>
				</Grid>
				<Grid item xs={3}>
					<Button className={classes.button} fullWidth variant="contained" color="primary" onClick={() => onButtonPress('.')}>
						.
					</Button>
				</Grid>
				<Grid item xs={3}>
					<Button className={classes.button} fullWidth variant="contained" color="primary" onClick={() => onButtonPress(0)}>
						0
					</Button>
				</Grid>
				<Grid item xs={3}>
					<Button className={classes.button} fullWidth variant="contained" color="secondary" onClick={() => onButtonPress('/')}>
						÷
					</Button>
				</Grid>
				<Grid item xs={3}>
					<Button className={classes.button} fullWidth variant="contained" color="secondary" onClick={() => onButtonPress('*')}>
						×
					</Button>
				</Grid>
				<Grid item xs={6}>
					<Button className={classes.button} fullWidth variant="contained" color="error" onClick={() => onButtonPress('reset')}>
						Reset
					</Button>
				</Grid>
				<Grid item xs={6}>
					<Button className={classes.button} fullWidth variant="contained" color="secondary" onClick={() => onButtonPress('=')}>
						=
					</Button>
				</Grid>
			</Grid>
		</div>
	);
};

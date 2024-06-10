import React from 'react';
import { useDispatch } from 'react-redux';
import { TextField } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../../util/Nui';
import { IconButton } from '@mui/material';

const useStyles = makeStyles((theme) => ({
	div: {
		width: '100%',
		fontSize: 13,
		fontWeight: 500,
		textAlign: 'center',
		textDecoration: 'none',
		textShadow: 'none',
		whiteSpace: 'nowrap',
		display: 'inline-block',
		verticalAlign: 'middle',
		borderRadius: 3,
		transition: '0.1s all linear',
		userSelect: 'none',
		color: '#ffffff',
		marginBottom: 5,
		lineHeight: '38px',
	},
	slider: {
		display: 'block',
		position: 'relative',
		top: '25%',
	},
	action: {
		height: 80,
		lineHeight: '80px',
		'&:not(.disabled):hover': {
			filter: 'brightness(0.6)',
			transition: 'filter ease-in 0.15s',
		},
	},
	textField: {
		width: 25,
		'& input': {
			textAlign: 'center',
			color: theme.palette.primary.main,
		},
		'& input::-webkit-clear-button, & input::-webkit-outer-spin-button, & input::-webkit-inner-spin-button':
			{
				display: 'none',
			},
	},
	wrapper: {
		display: 'grid',
		gridGap: 0,
		gridTemplateColumns: '20% 60% 20%',
		gridTemplateRows: '40px 40px',
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();

	const onLeft = () => {
		if (props.disabled) return;

		Nui.send('FrontEndSound', { sound: 'UPDOWN' });

		if (Boolean(props.onChange)) {
			props.onChange(
				props.current - 1 < 0 ? props.max : props.current - 1,
				props.data,
			);
		} else {
			dispatch(
				props.event(
					props.current - 1 < 0 ? props.max : props.current - 1,
					props.data,
				),
			);
		}
	};

	const onRight = () => {
		if (props.disabled) return;

		Nui.send('FrontEndSound', { sound: 'UPDOWN' });

		if (Boolean(props.onChange)) {
			props.onChange(
				props.current + 1 > props.max ? 0 : props.current + 1,
				props.data,
			);
		} else {
			dispatch(
				props.event(
					props.current + 1 > props.max ? 0 : props.current + 1,
					props.data,
				),
			);
		}
	};

	const updateIndex = (event) => {
		try {
			let v = parseInt(event.target.value, 10);

			if (!props.disabled) {
				if (event.target.value > props.max) {
					v = props.max;
				} else if (event.target.value < props.min) {
					v = props.min;
				}
				Nui.send('FrontEndSound', { sound: 'UPDOWN' });

				if (Boolean(props.onChange)) {
					props.onChange(v, props.data);
				} else {
					dispatch(props.event(v, props.data));
				}
			}
		} catch (err) {
			//console.log(err);
		}
	};

	const cssClass = props.disabled ? `${classes.div} disabled` : classes.div;
	const style = props.disabled ? { opacity: 0.5 } : {};

	return (
		<div className={cssClass} style={style}>
			<div className={classes.wrapper}>
				<div style={{ gridColumn: 2, gridRow: 1 }}>{props.label}</div>
				<div
					className={`${classes.action}${
						props.disabled || props.current === 0 ? ' disabled' : ''
					}`}
				>
					<IconButton
						onClick={onLeft}
						style={{ gridColumn: 1, gridRow: '1 / 2' }}
					>
						<FontAwesomeIcon icon={['fas', 'chevron-left']} />
					</IconButton>
				</div>
				<div style={{ gridColumn: 2, gridRow: 2 }}>
					<TextField
						variant="standard"
						value={props.current}
						className={classes.textField}
						onChange={updateIndex}
						disabled={props.disabled}
						type="number"
						pattern="[0-9]*"
						inputProps={{
							min: props.min,
							max: props.max,
							step: 1,
						}}
					/>{' '}
					/ {props.max}
				</div>
				<div
					className={`${classes.action}${
						props.disabled || props.current === 0 ? ' disabled' : ''
					}`}
				>
					<IconButton
						onClick={onRight}
						style={{ gridColumn: 1, gridRow: '1 / 2' }}
					>
						<FontAwesomeIcon icon={['fas', 'chevron-right']} />
					</IconButton>
				</div>
			</div>
		</div>
	);
};

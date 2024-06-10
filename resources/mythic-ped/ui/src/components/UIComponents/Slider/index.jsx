import React, { useState } from 'react';
import { Grid, Slider as MSlider, Tooltip } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useDispatch } from 'react-redux';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../../util/Nui';

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
		padding: '10px 20px',
		borderRadius: 3,
		transition: '0.1s all linear',
		userSelect: 'none',
		color: '#ffffff',
		marginBottom: 5,
	},
	label: {
		display: 'block',
		width: '100%',
	},
	slider: {
		display: 'block',
		position: 'relative',
		top: '25%',
	},
	saveContainer: {
		textAlign: 'right',
		color: '#38b58fab',
		'&:hover': {
			color: '#38b58f59',
		},
	},
	icon: {
		width: '0.75em',
		height: '100%',
		fontSize: '1.25rem',
		float: 'right',
		color: theme.palette.error.light,
		transition: 'filter ease-in 0.15s',
		'&:hover': {
			filter: 'brightness(0.7)',
		},
	},
}));

function ValueLabelComponent(props) {
	const { children, open, value } = props;

	return (
		<Tooltip open={open} enterTouchDelay={0} placement="top" title={value}>
			{children}
		</Tooltip>
	);
}

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const [currentValue, setCurrentValue] = useState(props.current);

	const onChange = (event, newValue) => {
		if (!props.disabled) {
			setCurrentValue(newValue);
			dispatch(props.event(currentValue, props.data));
		}
	};

	// const onSave = () => {
	// 	if (!props.disabled && props.current !== currentValue) {
	// 		Nui.send('FrontEndSound', { sound: 'SELECT' });
	// 		dispatch(props.event(currentValue, props.data));
	// 		dispatch(props.event(currentValue, props.data));
	// 	}
	// };

	const cssClass = props.disabled ? `${classes.div} disabled` : classes.div;
	const style = props.disabled ? { opacity: 0.5 } : {};

	return (
		<div className={cssClass} style={style}>
			<Grid container>
				<Grid item xs={12}>
					<span>{props.label}</span>
				</Grid>
				{/* <Grid
					item
					xs={2}
					className={classes.saveContainer}
					onClick={onSave}
				>
					{currentValue === props.current ? null : (
						<FontAwesomeIcon
							icon={['fas', 'circle-check']}
							className={classes.icon}
						/>
					)}
				</Grid> */}
				<Grid item xs={12}>
					<MSlider
						className={classes.slider}
						onChange={onChange}
						components={{
							ValueLabel: ValueLabelComponent,
						}}
						defaultValue={0}
						value={currentValue}
						disabled={props.disabled}
						step={1}
						min={props.min}
						max={props.max}
						component="div"
					/>
				</Grid>
			</Grid>
		</div>
	);
};

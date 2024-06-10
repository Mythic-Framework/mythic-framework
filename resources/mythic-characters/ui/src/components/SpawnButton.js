/* eslint-disable react/prop-types */
import React from 'react';
import { connect } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { selectSpawn } from '../actions/characterActions';

const useStyles = makeStyles((theme) => ({
	button: {
		padding: 25,
		background: 'transparent',
		color: theme.palette.text.main,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		transition: 'background ease-in 0.15s',
		userSelect: 'none',
		background: theme.palette.secondary.dark,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
		'&:hover': {
			background: theme.palette.secondary.main,
			cursor: 'pointer',
		},
		'&.selected': {
			background: theme.palette.secondary.light,
		},
	},
	special: {
		marginRight: 10,
		color: theme.palette.primary.main,
	},
}));

const SpawnButton = (props) => {
	const classes = useStyles();

	const onClick = () => {
		props.selectSpawn(props.spawn);
	};

	return (
		<div
			className={`${classes.button}${
				props?.selectedSpawn?.id == props.spawn.id ? ' selected' : ''
			}`}
			onClick={onClick}
		>
			{Boolean(props.spawn.icon) ? (
				<FontAwesomeIcon
					icon={props.spawn.icon}
					className={classes.special}
				/>
			) : null}
			{props.spawn.label}
		</div>
	);
};

const mapStateToProps = (state) => ({
	selected: state.characters.selected,
	selectedSpawn: state.spawn.selected,
});

export default connect(mapStateToProps, { selectSpawn })(SpawnButton);

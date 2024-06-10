import React from 'react';
import { connect } from 'react-redux';
import { Button, ButtonGroup } from '@mui/material';
import { makeStyles } from '@mui/styles';
import SpawnButton from '../../components/SpawnButton';
import { spawnToWorld, deselectCharacter } from '../../actions/characterActions';

const useStyles = makeStyles((theme) => ({
	container: {
		position: 'absolute',
		top: '5%',
		right: '5%',
		height: '90%',
		width: 450,
	},
	wrapper: {},
	innerWrapper: {
		position: 'absolute',
		width: 450,
		height: '100%',
		overflow: 'hidden',
		textAlign: 'center',
		maxHeight: '100%',
		background: theme.palette.secondary.dark,
	},
	body: {
		height: 'fit-content',
		display: 'block',
		width: '100%',
		maxHeight: '94%',
		height: '100%',
		background: theme.palette.secondary.dark,
		position: 'relative',
		overflowY: 'auto',
		overflowX: 'hidden',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#333333',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: theme.palette.secondary.dark,
		},
	},
	header: {
		borderLeft: `1px solid ${theme.palette.secondary.main}`,
		padding: 15,
		fontSize: 24,
		background: theme.palette.secondary.light,
		color: theme.palette.text.main,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
	},
	positive: {
		border: `2px solid ${theme.palette.success.dark}`,
		background: theme.palette.success.main,
		color: theme.palette.text.dark,
		fontSize: 20,
		padding: 10,
		width: 105,
		textAlign: 'center',
		transition: 'filter ease-in 0.15s',
		'&:hover': {
			borderColor: `${theme.palette.success.dark} !important`,
			boxShadow: 'none',
			background: theme.palette.success.main,
			filter: 'brightness(0.7)',
		},
	},
	negative: {
		border: `2px solid ${theme.palette.error.dark}`,
		background: theme.palette.error.main,
		color: theme.palette.text.main,
		fontSize: 20,
		padding: 10,
		width: 105,
		textAlign: 'center',
		transition: 'filter ease-in 0.15s',
		'&:hover': {
			background: theme.palette.error.main,
			filter: 'brightness(0.7)',
		},
	},
	actions: {
		position: 'absolute',
		width: 'fit-content',
		height: 'fit-content',
		bottom: '5%',
		left: 0,
		right: 0,
		margin: 'auto',
	},
}));
const Spawn = (props) => {
	const classes = useStyles();

	const onSpawn = () => {
		props.spawnToWorld(props.selected, props.selectedChar);
	};

	const goBack = () => {
		props.deselectCharacter();
	};

	return (
		<>
			<div className={classes.container}>
				<div className={classes.wrapper}>
					<div className={classes.innerWrapper}>
						<div className={classes.header}>
							<span>Select Your Spawn</span>
						</div>
						<div className={classes.body}>
							{props.spawns.map((spawn, i) => {
								return <SpawnButton key={i} type="button" spawn={spawn} />;
							})}
						</div>
					</div>
				</div>
			</div>
			<div className={classes.actions}>
				<ButtonGroup>
					<Button onClick={goBack} className={classes.negative}>
						Cancel
					</Button>
					{Boolean(props.selected) && (
						<Button onClick={onSpawn} className={classes.positive}>
							Play
						</Button>
					)}
				</ButtonGroup>
			</div>
		</>
	);
};

const mapStateToProps = (state) => ({
	spawns: state.spawn.spawns,
	selected: state.spawn.selected,
	selectedChar: state.characters.selected,
});

export default connect(mapStateToProps, {
	deselectCharacter,
	spawnToWorld,
})(Spawn);

/* eslint-disable react/no-array-index-key */
/* eslint-disable react/prop-types */
import React from 'react';
import { connect } from 'react-redux';
import {
	Button,
	ButtonGroup,
	Dialog,
	DialogActions,
	DialogContent,
	DialogContentText,
	DialogTitle,
	List,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Character from '../../components/Character';
import { showCreator, deleteCharacter, getCharacterSpawns } from '../../actions/characterActions';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		width: 450,
		height: '90%',
		position: 'absolute',
		top: 0,
		bottom: 0,
		right: '5%',
		margin: 'auto',
		background: theme.palette.secondary.dark,
	},
	createButton: {
		position: 'absolute',
		left: -63,
		borderRadius: 0,
		padding: 13,
		background: theme.palette.primary.main,
		boxShadow: 'none',
		fontSize: 16,
		border: 'none',
		'&:hover': {
			background: theme.palette.primary.dark,
			boxShadow: 'none',
		},
		'&:active': {
			boxShadow: 'none',
		},
		'&:focus': {
			boxShadow: 'none',
		},
	},
	bodyWrapper: {
		display: 'inline-block',
		width: '100%',
		height: '96%',
		overflow: 'hidden',
	},
	motd: {
		'& span::before': {
			content: '"Message of the Day:"',
			color: theme.palette.primary.main,
			marginRight: 5,
		},
		borderLeft: `1px solid ${theme.palette.secondary.main}`,
		padding: 15,
		background: theme.palette.secondary.main,
		color: theme.palette.text.main,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
	},
	charList: {
		padding: 0,
		overflowY: 'auto',
		overflowX: 'hidden',
		height: '100%',
		display: 'block',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#131317',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: theme.palette.secondary.main,
		},
	},
	button: {
		fontSize: 14,
		lineHeight: '20px',
		fontWeight: '500',
		display: 'inline-block',
		padding: '10px 20px',
		borderRadius: 3,
		userSelect: 'none',
		margin: 10,
		width: '40%',
		'&:disabled': {
			opacity: 0.5,
			cursor: 'not-allowed',
		},
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
			borderColor: `${theme.palette.error.dark} !important`,
			background: theme.palette.error.main,
			filter: 'brightness(0.7)',
		},
	},
	noChar: {
		margin: 15,
		padding: 15,
		border: `2px solid ${theme.palette.secondary.dark}`,
		textAlign: 'center',
		color: theme.palette.text.main,
		'&:hover': {
			borderColor: '#2f2f2f',
			transition: 'border-color ease-in 0.15s',
			cursor: 'pointer',
		},
		'& h3': {
			color: theme.palette.primary.main,
		},
		'& span': {
			color: '#38b58f',
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

const Characters = (props) => {
	const classes = useStyles();

	const [open, setOpen] = React.useState(false);

	const createCharacter = () => {
		props.showCreator();
	};

	const playCharacter = () => {
		props.getCharacterSpawns(props.selected);
	};

	const deleteChar = () => {
		props.deleteCharacter(props.selected.ID);
		setOpen(false);
	};

	return (
		<>
			<div className={classes.wrapper}>
				<Button className={classes.createButton} variant="contained" color="primary" onClick={createCharacter}>
					<FontAwesomeIcon icon={['fas', 'square-plus']} />
				</Button>
				<div className={classes.bodyWrapper}>
					<div className={classes.motd}>
						<span>{props.motd}</span>
					</div>
					<List className={classes.charList}>
						{props.characters.length > 0 ? (
							props.characters.map((char, i) => <Character key={i} id={i} character={char} />)
						) : (
							<div className={classes.noChar} onClick={createCharacter}>
								<h3>No Characters</h3>
								<span>+ Create New Character</span>
							</div>
						)}
					</List>
				</div>
			</div>
			{Boolean(props.selected) && (
				<div className={classes.actions}>
					<ButtonGroup>
						<Button onClick={() => setOpen(true)} className={classes.negative}>
							Delete
						</Button>
						<Button onClick={playCharacter} className={classes.positive}>
							Play
						</Button>
					</ButtonGroup>
				</div>
			)}
			{props.selected != null && (
				<Dialog open={open} onClose={() => setOpen(false)}>
					<DialogTitle>{`Delete ${props.selected.First} ${props.selected.Last}?`}</DialogTitle>
					<DialogContent>
						<DialogContentText>
							Are you sure you want to delete {props.selected.First} {props.selected.Last}? This action is
							completely & entirely irreversible by{' '}
							<i>
								<b>anyone</b>
							</i>{' '}
							including staff. Proceed?
						</DialogContentText>
					</DialogContent>
					<DialogActions>
						<Button onClick={() => setOpen(false)} color="inherit">
							No
						</Button>
						<Button onClick={deleteChar} color="primary" autoFocus>
							Yes
						</Button>
					</DialogActions>
				</Dialog>
			)}
		</>
	);
};

const mapStateToProps = (state) => ({
	characters: state.characters.characters,
	selected: state.characters.selected,
	changelog: state.characters.changelog,
	motd: state.characters.motd,
});

export default connect(mapStateToProps, {
	deleteCharacter,
	getCharacterSpawns,
	showCreator,
})(Characters);

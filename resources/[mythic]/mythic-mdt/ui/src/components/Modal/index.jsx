import React, { useEffect } from 'react';
import {
	Dialog,
	DialogActions,
	DialogContent,
	DialogTitle,
	Button,
	Paper,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useSelector } from 'react-redux';
import Draggable from 'react-draggable';

const useStyles = makeStyles((theme) => ({
	popup: {
		paddingTop: `5px !important`,
		maxHeight: `750px !important`,
	},
}));

function PaperComponent(props) {
	return (
		<Draggable
			handle="#draggable-dialog-title"
			cancel={'[class*="MuiDialogContent-root"]'}
		>
			<Paper {...props} />
		</Draggable>
	);
}

export default ({
	open,
	title,
	maxWidth = 'md',
	submitLang = 'Save',
	acceptLang = 'OK',
	deleteLang = 'Delete',
	closeLang = 'Close',
	onClose = null,
	onSubmit = null,
	onAccept = null,
	onDelete = null,
	children,
}) => {
	const classes = useStyles();
	const mdtOpen = !useSelector((state) => state.app.hidden);

	return (
		<Dialog
			maxWidth={maxWidth}
			fullWidth
			PaperComponent={PaperComponent}
			scroll="paper"
			open={open && mdtOpen}
			onClose={onClose}
		>
			{Boolean(onSubmit) ? (
				<form onSubmit={onSubmit}>
					<DialogTitle
						style={{ cursor: 'move' }}
						id="draggable-dialog-title"
					>
						{title}
					</DialogTitle>
					<DialogContent className={classes.popup}>
						{children}
					</DialogContent>
					<DialogActions>
						{Boolean(onDelete) && (
							<Button type="button" onClick={onDelete}>
								{deleteLang}
							</Button>
						)}
						<Button type="button" onClick={onClose}>
							{closeLang}
						</Button>
						<Button type="submit">{submitLang}</Button>
					</DialogActions>
				</form>
			) : (
				<>
					<DialogTitle
						style={{ cursor: 'move' }}
						id="draggable-dialog-title"
					>
						{title}
					</DialogTitle>
					<DialogContent className={classes.popup}>
						{children}
					</DialogContent>
					<DialogActions>
						{Boolean(onDelete) && (
							<Button type="button" onClick={onDelete}>
								{deleteLang}
							</Button>
						)}
						<Button type="button" onClick={onClose}>
							{closeLang}
						</Button>
						{Boolean(onAccept) && (
							<Button type="button" onClick={onAccept}>
								{acceptLang}
							</Button>
						)}
					</DialogActions>
				</>
			)}
		</Dialog>
	);
};

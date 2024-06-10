import React, { useEffect, useRef } from 'react';
import {
	Dialog,
	DialogActions,
	DialogContent,
	DialogTitle,
	Button,
	Paper,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
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

	const formRef = useRef();

	useEffect(() => {
		return () => {
			if (Boolean(formRef?.current)) formRef.current.reset();
		};
	}, []);

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
				<form onSubmit={onSubmit} ref={formRef}>
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
							<Button
								type="button"
								color="error"
								variant="contained"
								onClick={onDelete}
							>
								{deleteLang}
							</Button>
						)}
						<Button type="button" color="primary" onClick={onClose}>
							{closeLang}
						</Button>
						<Button
							type="submit"
							color="primary"
							variant="contained"
						>
							{submitLang}
						</Button>
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
							<Button
								type="button"
								color="error"
								variant="contained"
								onClick={onDelete}
							>
								{deleteLang}
							</Button>
						)}
						<Button type="button" color="primary" onClick={onClose}>
							{closeLang}
						</Button>
						{Boolean(onAccept) && (
							<Button
								type="button"
								color="primary"
								variant="contained"
								onClick={onAccept}
							>
								{acceptLang}
							</Button>
						)}
					</DialogActions>
				</>
			)}
		</Dialog>
	);
};

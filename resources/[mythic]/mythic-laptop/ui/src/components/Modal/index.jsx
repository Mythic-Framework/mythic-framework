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
		paddingTop: `2px !important`,
		maxHeight: `450px !important`,
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
	submitColor = 'primary',
	acceptLang = 'OK',
	acceptColor = 'primary',
	deleteLang = 'Delete',
	deleteColor = 'primary',
	closeLang = 'Close',
	closeColor = 'primary',
	onClose = null,
	onSubmit = null,
	onAccept = null,
	onDelete = null,
	disabled = false,
	children,
}) => {
	const classes = useStyles();
	const laptopOpen = !useSelector((state) => state.laptop.hidden);

	return (
		<Dialog
			maxWidth={maxWidth}
			fullWidth
			PaperComponent={PaperComponent}
			scroll="paper"
			open={open && laptopOpen}
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
							<Button
								type="button"
								disabled={disabled}
								color={deleteColor}
								onClick={onDelete}
							>
								{deleteLang}
							</Button>
						)}
						<Button
							type="button"
							disabled={disabled}
							color={closeColor}
							onClick={onClose}
						>
							{closeLang}
						</Button>
						<Button type="submit" color={submitColor}>
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
							<Button type="button" onClick={onDelete}>
								{deleteLang}
							</Button>
						)}
						<Button
							type="button"
							disabled={disabled}
							color={closeColor}
							onClick={onClose}
						>
							{closeLang}
						</Button>
						{Boolean(onAccept) && (
							<Button
								type="button"
								disabled={disabled}
								color={acceptColor}
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

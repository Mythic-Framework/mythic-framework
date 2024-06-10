import React, { useState } from 'react';
import { connect } from 'react-redux';
import {
	Dialog,
	DialogTitle,
	DialogContent,
	DialogActions,
	Button,
} from '@mui/material';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({}));

export default ({
	open,
	title,
	onAccept,
	onDecline,
	children,
	declineLang = 'Cancel',
	acceptLang = 'Save',
}) => {
	const classes = useStyles();

	return (
		<Dialog fullWidth maxWidth="sm" open={open}>
			<DialogTitle>{title}</DialogTitle>
			<DialogContent dividers>{children}</DialogContent>
			<DialogActions>
				<Button onClick={onDecline}>
					{declineLang}
				</Button>
				<Button onClick={onAccept}>{acceptLang}</Button>
			</DialogActions>
		</Dialog>
	);
};

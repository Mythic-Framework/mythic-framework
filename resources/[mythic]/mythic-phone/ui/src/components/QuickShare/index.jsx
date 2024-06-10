import React, { useState } from 'react';
import { connect, useDispatch, useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { makeStyles } from '@material-ui/styles';
import RandomMC from 'random-material-color';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../util/Nui';
import { useAlert } from '../../hooks';
import { Modal } from '../../components';
import { install } from '../../Apps/store/action';

const useStyles = makeStyles((theme) => ({}));

export default connect(null, { install })((props) => {
	const showAlert = useAlert();
	const classes = useStyles();
	const history = useHistory();
	const dispatch = useDispatch();
	const open = useSelector((state) => state.share.open);
	const sharing = useSelector((state) => state.share.sharing);

	const onClose = () => {
		dispatch({
			type: 'USE_SHARE',
			payload: false,
		});
	};

	const onSave = async () => {
		try {
			let res = await (await Nui.send('SaveShare', sharing)).json();

			if (res) {
				showAlert('Saved');
				dispatch({
					type: 'REMOVE_SHARE',
				});
			} else {
				showAlert('Unable to Save');
				onClose();
			}
		} catch (err) {
			console.log(err);
			showAlert('Unable to Save');
			onClose();
		}
	};

	const onCancel = async () => {
		try {
			dispatch({
				type: 'REMOVE_SHARE',
			});
			showAlert('Rejected Share');
		} catch (err) {
			console.log(err);
			showAlert('Rejected Share');
		}
	};

	if (sharing) {
		switch (sharing.type) {
			case 'contacts':
				return (
					<Modal
						open={open}
						title="QuickShare: Contact"
						onClose={onClose}
						onAccept={onSave}
						acceptLang="Save Contact"
						closeLang="Cancel"
					>
						<div>
							<div>Name: {sharing.data.name}</div>
							<div>Number: {sharing.data.number}</div>
						</div>
					</Modal>
				);
			case 'documents':
				return (
					<Modal
						open={open}
						title={sharing.data.isCopy ? "QuickShare: Copy of Document" : "QuickShare: Document"}
						onClose={onClose}
						onAccept={onSave}
						acceptLang="Save Document"
						closeLang="Cancel"
					>
						<div>
							<div>Title: {sharing.data?.document?.title ?? 'Unknown'}</div>
						</div>
					</Modal>
				);
			default:
				return null;
		}
	} else {
		return null;
	}
});

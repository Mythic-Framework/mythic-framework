import React, { useState } from 'react';
import {
	IconButton,
	ListItem,
	ListItemText,
	ListItemSecondaryAction,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Confirm } from '../../../components';
import Nui from '../../../util/Nui';
import { useAlert } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
}));

export default ({ property, data, canRevoke, onRefresh, onUpdate }) => {
	const classes = useStyles();
	const showAlert = useAlert();

	const [deleting, setDeleting] = useState(false);

	const onDelete = async (e) => {
		try {
			let res = await (
				await Nui.send('Home:RevokeDigiKey', {
					id: property.id,
					target: data.Char,
				})
			).json();

			if (!res.error) {
				showAlert('DigiKey Has Been Revoked');
				setDeleting(false);
				onRefresh();
			} else {
				switch (res.code) {
					case 1:
						showAlert('Error Occured');
						break;
					case 2:
						showAlert('Invalid Property');
						break;
					case 3:
						showAlert('Not Allowed');
						break;
					case 4:
						showAlert('Invalid Target Player');
						break;
					case 5:
						showAlert('Invalid Target Character');
						break;
					case 6:
						showAlert("Person Doesn't Have A DigiKey For Property");
						break;
					case 7:
						showAlert('Error Occured Revoking DigiKey');
						break;
				}
			}
		} catch (err) {
			console.log(err);
		}
	};

	return (<>
		<ListItem divider>
			<ListItemText
				primary={`${data.First} ${data.Last}`}
				secondary={data.Owner ? 'Owner' : 'Key Holder'}
			/>
			{canRevoke && (
				<ListItemSecondaryAction>
					<IconButton onClick={onUpdate}>
						<FontAwesomeIcon icon={['fas', 'pen-to-square']} />
					</IconButton>
					<IconButton onClick={() => setDeleting(true)}>
						<FontAwesomeIcon icon={['fas', 'trash']} />
					</IconButton>
				</ListItemSecondaryAction>
			)}
		</ListItem>
		{canRevoke && (
			<Confirm
				title="Revoke DigiKey?"
				open={deleting}
				confirm="Yes"
				decline="No"
				onConfirm={onDelete}
				onDecline={() => setDeleting(false)}
			>
				<p>
					Removing the DigiKey will revoke access to this property
					and shared assets for this person. Are you sure?
				</p>
			</Confirm>
		)}
	</>);
};

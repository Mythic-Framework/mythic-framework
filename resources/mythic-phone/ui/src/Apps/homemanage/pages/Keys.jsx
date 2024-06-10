import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
	List,
	ListItem,
	ListItemText,
	Fab,
	TextField,
	Select,
	OutlinedInput,
	FormControl,
	MenuItem,
	InputLabel,
	Checkbox,
	FormHelperText,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import NumberFormat from 'react-number-format';

import { Loader, Modal } from '../../../components';
import DigiKey from '../components/DigiKey';
import { useAlert } from '../../../hooks';
import Nui from '../../../util/Nui';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflow: 'hidden',
	},
	header: {
		background: '#30518c',
		fontSize: 20,
		padding: 15,
		lineHeight: '50px',
		height: 78,
	},
	headerAction: {},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	fab: {
		backgroundColor: '#30518c',
		position: 'absolute',
		bottom: '20%',
		right: '10%',
	},
	list: {
		height: '100%',
		//overflow: 'auto',
		overflowX: 'hidden',
		overflowY: 'auto',
	},
	editorField: {
		marginBottom: 15,
	},
}));

const propertyPermissions = [
	{
		value: "upgrade",
		name: "Manage Upgrades",
	},
	{
		value: "furniture",
		name: "Manage Furniture",
	},
]

export default ({ property, onRefresh, myKey }) => {
	const classes = useStyles();
	const showAlert = useAlert();

	const [loading, setLoading] = useState(false);
	const [creating, setCreating] = useState(false);

	const [permissions, setPermissions] = useState(Object());

	const [key, setKey] = useState({});

	const onAdd = async (e) => {
		e.preventDefault();
		setLoading(true);
		try {
			let res = await (
				await Nui.send('Home:CreateDigiKey', {
					updating: key?.updating,
					id: property.id,
					target: +key?.target,
					permissions: permissions,
				})
			).json();

			if (!res.error) {
				showAlert(key?.updating ? 'DigiKey Has Been Updated' : 'New DigiKey Has Been Issued');
				setCreating(false);
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
						showAlert('Person Already Has DigiKey For Property');
						break;
					case 7:
						showAlert('Error Occured Issuing DigiKey');
						break;
				}
			}
		} catch (err) {
			console.log(err);
			showAlert('Unable to Create DigiKey');
		}
		setLoading(false);
	};

	const onStartUpdate = (data) => {
		setPermissions(data.Permissions ?? Object());
		setKey({
			updating: true,
			target: data.SID,
		});

		setCreating(true);
	};

	return (
		<div className={classes.wrapper}>
			<List className={classes.list}>
				{Object.keys(property.keys)
					.sort(
						(a, b) =>
							property.keys[b].Owner - property.keys[a].Owner,
					)
					.map((k) => {
						let data = property.keys[k];
						return (
							<DigiKey
								key={k}
								property={property}
								data={data}
								canRevoke={myKey.Owner && !data.Owner}
								onRefresh={onRefresh}
								onUpdate={() => onStartUpdate(data)}
							/>
						);
					})}
			</List>
			{myKey.Owner && (
				<>
					<Fab
						className={classes.fab}
						onClick={() => {
							setKey({});
							setCreating(true);
						}}
					>
						<FontAwesomeIcon icon={['fas', 'plus']} />
					</Fab>
					<Modal
						form
						formStyle={{ position: 'relative' }}
						disabled={loading}
						open={creating}
						title={key?.updating ? "Update DigiKey" : "Create New DigiKey"}
						onAccept={onAdd}
						onClose={() => setCreating(false)}
						submitLang={key?.updating ? "Update" : "Create"}
					>
						<>
							{loading && (
								<Loader static text={key?.updating ? "Updating DigiKey" : "Creating DigiKey"} />
							)}
							<NumberFormat
								fullWidth
								required
								label="Target State ID"
								name="target"
								type="tel"
								isNumericString
								customInput={TextField}
								disabled={loading || key?.updating}
								className={classes.editorField}
								value={key.target}
								onChange={e => {
									setKey({
										...key,
										[e.target.name]: e.target.value,
									});
								}}
							/>
							<FormControl fullWidth className={classes.editorField}>
								<InputLabel id="permissions">
									Permissions
								</InputLabel>
								<Select
									id="permissions"
									name="permissions"
									disabled={loading}
									value={Object.keys(permissions)}
									labelId="permissions"
									multiple
									fullWidth
									input={
										<OutlinedInput
											fullWidth
											label="Permissions"
										/>
									}
									renderValue={(selected) => selected.map(k => propertyPermissions.find(p => p.value == k)?.name ?? k).join(', ')}
									onChange={(e) => {
										let t = Object();
										e.target.value.map((p) => {
											t[p] = true;
										});
										setPermissions(t);
									}}
								>
									{propertyPermissions.map(p => {
										return (
											<MenuItem key={p.value} value={p.value}>
												<Checkbox checked={Object.keys(permissions).indexOf(p.value) > -1} />
												<ListItemText primary={p.name} />
											</MenuItem>
										)
									})}
								</Select>
								<FormHelperText>Select Permissions</FormHelperText>
							</FormControl>
						</>
					</Modal>
				</>
			)}
		</div>
	);
};

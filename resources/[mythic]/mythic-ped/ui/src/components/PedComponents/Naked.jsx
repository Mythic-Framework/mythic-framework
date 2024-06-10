import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { FormGroup, FormControlLabel, Checkbox } from '@mui/material';
import { makeStyles } from '@mui/styles';

import Nui from '../../util/Nui';
import PedModels from './Ped/peds';

const useStyles = makeStyles((theme) => ({
	nekked: {
		position: 'absolute',
		top: 0,
		left: 8,
		width: 'fit-content',
		margin: 'auto',
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const isNekked = useSelector((state) => state.app.isNekked);
	const isForced = useSelector((state) => state.app.forcedNekked);
	const gender = useSelector((state) => state.app.gender);
	const model = useSelector((state) => state.app.ped.model);
	const peds = PedModels[gender];
	const curr = peds.indexOf(model) == -1 ? 0 : peds.indexOf(model);

	const [loading, setLoading] = useState(false);

	useEffect(() => {
		const e = async () => {
			setLoading(true);
			let res = await (
				await Nui.send('ToggleNekked', isNekked || isForced)
			).json();
			setTimeout(() => {
				setLoading(false);
			}, 1000);
		};
		e();
	}, [isNekked, isForced]);

	const onChange = async (e) => {
		try {
			Nui.send('FrontEndSound', { sound: 'SELECT' });
			dispatch({
				type: 'SET_NEKKED',
				payload: { state: !isNekked },
			});
		} catch (err) {}
	};

	return (
		<FormGroup className={classes.nekked}>
			<FormControlLabel
				control={
					<Checkbox
						checked={isNekked || isForced}
						disabled={isForced || loading || curr != 0}
					/>
				}
				label="Lets Get Nekked"
				onChange={onChange}
			/>
		</FormGroup>
	);
};

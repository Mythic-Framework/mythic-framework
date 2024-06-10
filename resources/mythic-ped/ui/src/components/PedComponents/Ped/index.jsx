import ElementBox from '../../UIComponents/ElementBox/ElementBox';
import React, { useEffect, useState } from 'react';
import { makeStyles } from '@mui/styles';
import { connect, useDispatch, useSelector } from 'react-redux';

import { Checkbox, Ticker } from '../../UIComponents';
import { SetPed } from '../../../actions/pedActions';
import Nui from '../../../util/Nui';
import PedModels from './peds';
import { Alert } from '@mui/material';

const useStyles = makeStyles((theme) => ({
	body: {
		maxHeight: '100%',
		overflow: 'hidden',
		margin: 25,
		display: 'grid',
		gridGap: 0,
		gridTemplateColumns: '100%',
		justifyContent: 'space-around',
		background: theme.palette.secondary.light,
		border: `2px solid ${theme.palette.border.divider}`,
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const gender = useSelector((state) => state.app.gender);
	const peds = PedModels[gender];
	const curr =
		peds.indexOf(props.model) == -1 ? 0 : peds.indexOf(props.model);

	const [disabled, setDisabled] = useState(false);

	const onChange = async (v, d) => {
		try {
			setDisabled(true);
			const payload = { value: peds[v] };
			let res = await (await Nui.send('SetPed', payload)).json();
			if (res) {
				dispatch({
					type: 'UPDATE_PED',
					payload,
				});
			}
			setDisabled(false);
		} catch (err) {
			console.log(err);
			setDisabled(false);
		}
	};

	return (
		<>
			<ElementBox bodyClass={classes.body}>
				<Alert severity="warning">
					Using any other model than 0 (MP Ped) may result in some
					options within the customization options not working as
					intended, or at all. YOU'VE BEEN WARNED.
				</Alert>
			</ElementBox>
			<ElementBox label={'Ped Model'} bodyClass={classes.body}>
				<Ticker
					label={'Model'}
					data={{}}
					current={curr}
					min={0}
					max={peds.length - 1}
					disabled={disabled}
					onChange={onChange}
				/>
			</ElementBox>
		</>
	);
};

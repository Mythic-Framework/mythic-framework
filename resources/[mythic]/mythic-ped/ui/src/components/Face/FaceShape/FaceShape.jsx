import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { FormGroup, FormControlLabel, Checkbox } from '@mui/material';
import { makeStyles } from '@mui/styles';

import { Slider, Ticker } from '../../UIComponents';
import { SetPedHeadBlendData } from '../../../actions/pedActions';
import ElementBox from '../../UIComponents/ElementBox/ElementBox';

const useStyles = makeStyles((theme) => ({
	advCheck: {
		width: 'fit-content',
		margin: 'auto',
		padding: 15,
	},
	body: {
		maxHeight: '100%',
		overflowX: 'hidden',
		overflowY: 'auto',
		display: 'grid',
		gridGap: 0,
		gridTemplateColumns: '100%',
		justifyContent: 'space-between',
		margin: 25,
		background: theme.palette.secondary.light,
		border: `2px solid ${theme.palette.border.divider}`,
		'&.advanced': {
			gridTemplateColumns: '50% 50%',
		},
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const ped = useSelector((state) => state.app.ped);

	const [advanced, setAdvanced] = useState(
		ped.customization.face.face3.mix == 0,
	);

	useEffect(() => {
		setAdvanced(ped.customization.face.face3.mix == 0);
	}, [ped]);

	const onCheckChange = (e) => {
		if (advanced) {
			dispatch(SetPedHeadBlendData(100, { type: 'mix', face: 'face3' }));
		} else {
			dispatch(SetPedHeadBlendData(0, { type: 'mix', face: 'face3' }));
		}
		//dispatch(SetPedHeadBlendData(0, { face: 'face3', type: 'index' }));
	};

	return (
		<div style={{ height: '100%' }}>
			<FormGroup className={classes.advCheck}>
				<FormControlLabel
					control={<Checkbox checked={advanced} />}
					label="Advanced Face Mixers"
					onChange={onCheckChange}
				/>
			</FormGroup>
			{!advanced ? (
				<>
					<ElementBox
						label={'Face & Skin'}
						bodyClass={`${classes.body}${
							advanced ? ' advanced' : ''
						}`}
					>
						<Ticker
							label={'Shape'}
							event={SetPedHeadBlendData}
							data={{
								face: 'face3',
								type: 'index',
							}}
							current={ped.customization.face.face3.index}
							min={0}
							max={46}
						/>
					</ElementBox>
				</>
			) : (
				<>
					<ElementBox label={'Face 1'} bodyClass={classes.body}>
						<Ticker
							label={'Shape'}
							event={SetPedHeadBlendData}
							data={{
								face: 'face1',
								type: 'index',
							}}
							current={ped.customization.face.face1.index}
							min={0}
							max={46}
						/>
						<Ticker
							label={'Skin'}
							event={SetPedHeadBlendData}
							data={{
								face: 'face1',
								type: 'texture',
							}}
							current={ped.customization.face.face1.texture}
							min={0}
							max={46}
						/>
					</ElementBox>
					<ElementBox label={'Face 2'} bodyClass={classes.body}>
						<Ticker
							label={'Shape'}
							event={SetPedHeadBlendData}
							data={{
								face: 'face2',
								type: 'index',
							}}
							current={ped.customization.face.face2.index}
							min={0}
							max={46}
						/>
						<Ticker
							label={'Skin'}
							event={SetPedHeadBlendData}
							data={{
								face: 'face2',
								type: 'texture',
							}}
							current={ped.customization.face.face2.texture}
							min={0}
							max={46}
						/>
					</ElementBox>
					<ElementBox label={'Mixes'} bodyClass={classes.body}>
						<Slider
							label={'Face Shape Mix'}
							event={SetPedHeadBlendData}
							data={{
								type: 'mix',
								face: 'face1',
							}}
							current={ped.customization.face.face1.mix}
							min={0}
							max={100}
						/>
						<Slider
							label={'Skin Mix'}
							event={SetPedHeadBlendData}
							data={{
								type: 'mix',
								face: 'face2',
							}}
							current={ped.customization.face.face2.mix}
							min={0}
							max={100}
						/>
					</ElementBox>
				</>
			)}
		</div>
	);
};

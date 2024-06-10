import React from 'react';
import { makeStyles } from '@mui/styles';
import { useDispatch } from 'react-redux';

import Nui from '../../../util/Nui';
import { Checkbox, Slider, Ticker } from '../../UIComponents';
import { SetPedHeadOverlay } from '../../../actions/pedActions';
import ElementBox from '../../UIComponents/ElementBox/ElementBox';

const useStyles = makeStyles((theme) => ({
	body: {
		maxHeight: '100%',
		overflow: 'hidden',
		margin: 25,
		display: 'grid',
		gridGap: 0,
		gridTemplateColumns: '10% 45% 45%',
		justifyContent: 'space-around',
		background: theme.palette.secondary.light,
		border: `2px solid ${theme.palette.border.divider}`,
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();

	const onClick = () => {
		Nui.send('FrontEndSound', { sound: 'SELECT' });
		dispatch(
			SetPedHeadOverlay(!props.current.disabled, {
				...props.data,
				extraType: 'disabled',
			}),
		);
	};

	return (
		<ElementBox label={props.label} bodyClass={classes.body}>
			<Checkbox onClick={onClick} disabled={props.current.disabled} />
			<Ticker
				label={'Type'}
				event={SetPedHeadOverlay}
				data={{ ...props.data, extraType: 'index' }}
				current={props.current.index}
				min={0}
				max={props.max}
				disabled={props.current.disabled}
			/>
			<Slider
				label={'Opacity'}
				event={SetPedHeadOverlay}
				disabled={props.current.disabled}
				data={{ ...props.data, extraType: 'opacity' }}
				current={props.current.opacity}
				min={0}
				max={100}
			/>
		</ElementBox>
	);
};

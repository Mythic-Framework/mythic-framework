import React from 'react';
import { makeStyles } from '@mui/styles';

import { Slider } from '../../UIComponents';
import { SetPedFaceFeature } from '../../../actions/pedActions';
import ElementBox from '../../UIComponents/ElementBox/ElementBox';

const useStyles = makeStyles((theme) => ({
	body: {
		maxHeight: '100%',
		overflowX: 'hidden',
		overflowY: 'auto',
		margin: 25,
		display: 'grid',
		gridGap: 0,
		gridTemplateColumns: '49% 49%',
		justifyContent: 'space-around',
		background: theme.palette.secondary.light,
		border: `2px solid ${theme.palette.border.divider}`,
	},
}));

export default (props) => {
	const classes = useStyles();

	const elements = props.data.items.map((item, i) => (
		<Slider
			key={i}
			label={item.label}
			event={SetPedFaceFeature}
			data={{
				index: item.index,
			}}
			current={item.current}
			min={-100}
			max={100}
		/>
	));

	return (
		<ElementBox label={props.label} bodyClass={classes.body}>
			{elements}
		</ElementBox>
	);
};

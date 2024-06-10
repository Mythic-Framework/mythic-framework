import ElementBox from '../../UIComponents/ElementBox/ElementBox';
import React, { useEffect } from 'react';
import { makeStyles } from '@mui/styles';
import { SetPedComponentVariation } from '../../../actions/pedActions';
import { Ticker } from '../../UIComponents';
import Nui from '../../../util/Nui';
import { connect, useSelector } from 'react-redux';

const hiddenThings = {
	accessory: [10],
};

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

export default connect()((props) => {
	const maxDrawables = useSelector(
		(state) => state.app.drawables.components[props.component.componentId],
	);
	const maxTextures = useSelector(
		(state) => state.app.textures.components[props.component.componentId],
	);

	const classes = useStyles();
	useEffect(() => {
		Nui.send('GetNumberOfPedDrawableVariations', {
			componentId: props.component.componentId,
		});
	}, []);

	useEffect(() => {
		if (!Boolean(maxDrawables)) return;

		Nui.send('GetNumberOfPedTextureVariations', {
			componentId: props.component.componentId,
			drawableId: maxDrawables[props.component.drawableId],
		});
		// props.dispatch(
		// 	SetPedComponentVariation(0, {
		// 		type: 'textureId',
		// 		name: props.name,
		// 	}),
		// );
	}, [props.component.drawableId, maxDrawables]);

	const onChange = (v, d) => {
		return (dispatch) => {
			dispatch(SetPedComponentVariation(maxDrawables[v], d));
			dispatch(
				SetPedComponentVariation(0, {
					type: 'textureId',
					name: props.name,
				}),
			);
		};
	};

	return (
		<ElementBox label={props.label} bodyClass={classes.body}>
			<Ticker
				label={props.label}
				event={onChange}
				data={{
					type: 'drawableId',
					name: props.name,
				}}
				current={
					Boolean(maxDrawables)
						? maxDrawables.indexOf(props.component.drawableId)
						: 0
				}
				min={0}
				max={Boolean(maxDrawables) ? maxDrawables.length - 1 : 0}
				disabled={props.disabled}
			/>
			<Ticker
				label={'Texture'}
				event={SetPedComponentVariation}
				data={{
					type: 'textureId',
					name: props.name,
				}}
				current={props.component.textureId}
				min={0}
				max={maxTextures ? maxTextures - 1 : 0}
				disabled={props.disabled}
			/>
		</ElementBox>
	);
});

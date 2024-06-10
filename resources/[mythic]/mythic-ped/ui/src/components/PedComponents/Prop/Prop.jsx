import ElementBox from '../../UIComponents/ElementBox/ElementBox';
import React, { useEffect } from 'react';
import { makeStyles } from '@mui/styles';
import { Checkbox, Ticker } from '../../UIComponents';
import { SetPedPropIndex } from '../../../actions/pedActions';
import { useDispatch, useSelector } from 'react-redux';
import Nui from '../../../util/Nui';

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

	const maxDrawables = useSelector(
		(state) => state.app.drawables.props[props.prop.componentId],
	);
	const maxTextures = useSelector(
		(state) => state.app.textures.props[props.prop.componentId],
	);

	useEffect(() => {
		Nui.send('GetNumberOfPedPropDrawableVariations', {
			componentId: props.prop.componentId,
		});
	}, []);

	useEffect(() => {
		Nui.send('GetNumberOfPedPropTextureVariations', {
			componentId: props.prop.componentId,
			drawableId: props.prop.drawableId,
		});
		// dispatch(
		// 	SetPedPropIndex(0, {
		// 		type: 'textureId',
		// 		name: props.name,
		// 	}),
		// );
	}, [props.prop.drawableId, maxDrawables]);

	const onChange = (v, d) => {
		return (dispatch) => {
			dispatch(SetPedPropIndex(v, d));
			dispatch(
				SetPedPropIndex(0, {
					type: 'textureId',
					name: props.name,
				}),
			);
		};
	};

	const onClick = () => {
		Nui.send('FrontEndSound', { sound: 'SELECT' });
		dispatch(
			SetPedPropIndex(!props.prop.disabled, {
				type: 'disabled',
				name: props.name,
			}),
		);
	};

	return (
		<ElementBox label={props.label} bodyClass={classes.body}>
			<Checkbox onClick={onClick} disabled={props.prop.disabled} />
			<Ticker
				label={props.label}
				event={onChange}
				data={{
					type: 'drawableId',
					name: props.name,
				}}
				current={props.prop.drawableId}
				min={0}
				max={maxDrawables ? maxDrawables.length - 1 : 0}
				disabled={props.prop.disabled}
			/>
			<Ticker
				label={'Texture'}
				event={SetPedPropIndex}
				data={{
					type: 'textureId',
					name: props.name,
				}}
				current={props.prop.textureId}
				min={0}
				max={maxTextures ? maxTextures - 1 : 0}
				disabled={props.prop.disabled}
			/>
		</ElementBox>
	);
};

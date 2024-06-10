import React from 'react';
import { useSelector } from 'react-redux';
import Prop from '../../PedComponents/Prop/Prop';

export default (props) => {
	const ped = useSelector((state) => state.app.ped);
	return (
		<div style={{ height: '100%' }}>
			<Prop
				label={'Hat'}
				prop={ped.customization.props.hat}
				name={'hat'}
			/>
			<Prop
				label={'Glasses'}
				prop={ped.customization.props.glass}
				name={'glass'}
			/>
			<Prop
				label={'Ears'}
				prop={ped.customization.props.ear}
				name={'ear'}
			/>
			<Prop
				label={'Watch'}
				prop={ped.customization.props.watch}
				name={'watch'}
			/>
			<Prop
				label={'Bracelet'}
				prop={ped.customization.props.bracelet}
				name={'bracelet'}
			/>
		</div>
	);
};

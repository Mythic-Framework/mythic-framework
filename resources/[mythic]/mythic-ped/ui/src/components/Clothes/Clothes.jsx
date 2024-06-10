import React, { useState } from 'react';
import { connect, useSelector } from 'react-redux';
import Wrapper from '../UIComponents/Wrapper/Wrapper';
import Component from '../PedComponents/Component/Component';

export default connect()(props => {
	const ped = useSelector(state => state.app.ped);

	return (
		<Wrapper>
			<Component
				label={'Shirt'}
				component={ped.customization.components.torso2}
				name={'torso2'}
			/>
			<Component
				label={'Under Shirt'}
				component={ped.customization.components.undershirt}
				name={'undershirt'}
			/>
			<Component
				label={'Vest'}
				component={ped.customization.components.kevlar}
				name={'kevlar'}
			/>
			<Component
				label={'Pants'}
				component={ped.customization.components.leg}
				name={'leg'}
			/>
			<Component
				label={'Shoes'}
				component={ped.customization.components.shoes}
				name={'shoes'}
			/>
		</Wrapper>
	);
});

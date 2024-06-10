import React, { useState } from 'react';
import { connect, useSelector } from 'react-redux';
import Component from '../../PedComponents/Component/Component';

export default connect()((props) => {
	const ped = useSelector((state) => state.app.ped);

	return (
		<div style={{ height: '100%' }}>
			<Component
				label={'Mask'}
				component={ped.customization.components.mask}
				name={'mask'}
			/>
			<Component
				label={'Bags'}
				component={ped.customization.components.bag}
				name={'bag'}
			/>
			<Component
				label={'Accessory'}
				component={ped.customization.components.accessory}
				name={'accessory'}
			/>
			<Component
				label={'Badges'}
				component={ped.customization.components.badge}
				name={'badge'}
			/>
		</div>
	);
});

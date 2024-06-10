import React, { Fragment } from 'react';
import { Overlay } from '../../PedComponents';
import { useSelector } from 'react-redux';

export default (props) => {
	const ped = useSelector((state) => state.app.ped);

	return (
		<div style={{ height: '100%' }}>
			<Overlay
				label={'Body Blemishes'}
				data={{
					type: 'bodyblemish',
					id: 11,
				}}
				current={ped.customization.overlay.bodyblemish}
				max={10}
			/>
			<Overlay
				label={'Additional Body Blemishes'}
				data={{
					type: 'addbodyblemish',
					id: 12,
				}}
				current={ped.customization.overlay.addbodyblemish}
				max={1}
			/>
		</div>
	);
};

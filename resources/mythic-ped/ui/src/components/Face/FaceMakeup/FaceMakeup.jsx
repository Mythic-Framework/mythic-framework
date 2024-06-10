import React, { Fragment } from 'react';
import { Overlay, OverlayColors } from '../../PedComponents';
import { useSelector } from 'react-redux';

export default (props) => {
	const ped = useSelector((state) => state.app.ped);

	return (
		<div style={{ height: '100%' }}>
			<Overlay
				label={'Makeup'}
				data={{
					type: 'makeup',
					id: 4,
				}}
				current={ped.customization.overlay.makeup}
				max={74}
			/>
			<OverlayColors
				label={'Makeup Colors'}
				data={{
					type: 'makeup',
					id: 4,
				}}
				current={ped.customization.overlay.makeup}
				secondary
			/>
			<Overlay
				label={'Blush'}
				data={{
					type: 'blush',
					id: 5,
				}}
				current={ped.customization.overlay.blush}
				max={6}
			/>
			<OverlayColors
				label={'Blush Colors'}
				data={{
					type: 'blush',
					id: 5,
				}}
				current={ped.customization.overlay.blush}
			/>
			<Overlay
				label={'Lipstick'}
				data={{
					type: 'lipstick',
					id: 8,
				}}
				current={ped.customization.overlay.lipstick}
				max={9}
			/>
			<OverlayColors
				label={'Lipstick Colors'}
				data={{
					type: 'lipstick',
					id: 8,
				}}
				current={ped.customization.overlay.lipstick}
			/>
		</div>
	);
};

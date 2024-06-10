import React from 'react';
import { useSelector } from 'react-redux';
import Ped from '../../PedComponents/Ped';

export default (props) => {
	const ped = useSelector((state) => state.app.ped);
	return (
		<div style={{ height: '100%' }}>
            <Ped model={ped.model} />
		</div>
	);
};

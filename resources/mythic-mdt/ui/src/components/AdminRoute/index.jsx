import React from 'react';
import { Navigate } from 'react-router-dom';
import { Outlet } from 'react-router';

import { Error } from '..';
import { usePermissions } from '../../hooks';

export default ({
	children,
	component: Component,
	permission = null,
	checkBnet = false,
	showError = false,
	...rest
}) => {
	const permCheck = usePermissions();

	return (
		<>
			{permCheck(permission ?? 'PD_HIGH_COMMAND') ? (
				<Outlet />
			) : showError ? (
				<Error static code={401} message="Not Authorized" />
			) : (
				<Navigate to="/" />
			)}
		</>
	);
};

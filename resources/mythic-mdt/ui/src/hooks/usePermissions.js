import { useSelector } from 'react-redux';

export default () => {
	const permissions = useSelector(state => state.app.govJobPermissions);
	const user = useSelector(state => state.app.user);
	return (permission, allowSysAdmin = true) => {
		if (Boolean(permission)) {
			return (
				Boolean(permissions) && (permissions[permission] || (allowSysAdmin && user?.MDTSystemAdmin))
			);
		} else return true;
	};
};

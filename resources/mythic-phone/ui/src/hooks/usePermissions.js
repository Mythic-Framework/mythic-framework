import { useSelector } from 'react-redux';

export default () => {
	const myPermissions = useSelector((state) => state.data.data.player.PhonePermissions);
	return (app, permission) => {
		if (Boolean(myPermissions) && Boolean(app) && Boolean(permission)) {
			return myPermissions[app][permission];
		} else return false;
	};
};

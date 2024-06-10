import { useSelector } from 'react-redux';

export default () => {
	const myPerms = useSelector((state) => state.data.data.JobPermissions);
	return (permissionKey, job = false) => {
		if (!Array.isArray(myPerms) && Boolean(permissionKey)) {
			if (Boolean(job)) {
				if (myPerms[job]) {
					return myPerms[job][permissionKey]
				}
			} else {
				Object.values(myPerms).forEach(jobPerms => {
					return jobPerms[permissionKey];
				});
			}
		} else return false;
	};
};

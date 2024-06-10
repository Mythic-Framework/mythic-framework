import { useSelector } from 'react-redux';

import {
	usePermissions,
	useJobPermissions,
	useMyStates,
	useMyJob,
	useReputation,
} from './';

export default () => {
	const hasJob = useMyJob();
	const hasJobPerm = useJobPermissions();
	const hasPhonePerm = usePermissions();
	const hasState = useMyStates();
	const hasRep = useReputation();
	const apps = useSelector((state) => state.phone.apps);
	const limited = useSelector((state) => state.phone.limited);

	let avail = Array();
	Object.keys(apps).map((k) => {
		let a = apps[k];
		if (
			(!limited || (limited && a.name == 'phone')) &&
			(!a.restricted ||
				(a.restricted.job && hasJob(a.restricted.job)) ||
				(a.restricted.state && hasState(a.restricted.state)) ||
				(a.restricted.jobPermission &&
					hasJobPerm(a.restricted.jobPermission)) ||
				(a.restricted.phonePermission &&
					hasPhonePerm(a.name, a.restricted.phonePermission)) ||
				(a.restricted.reputation &&
					hasRep(
						a.restricted.reputation,
						a.restricted.reputationAmount || 0,
					)))
		) {
			avail[a.name] = a;
		}
	});
	return avail;
};

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
	const apps = useSelector((state) => state.laptop.apps);

	const checkStates = (checking) => {
		if (typeof checking == "object") {
			return checking.every(state => hasState(state));
		} else {
			return hasState(checking);
		}
	};

	let avail = Array();
	Object.keys(apps).map((k) => {
		let a = apps[k];

		if (a.restricted) {
			if (Object.keys(a.restricted).every(permType => {
				if ((permType == "job" && hasJob(a.restricted.job)) ||
				(permType == "state" && checkStates(a.restricted.state)) ||
				(permType == "jobPermission" && hasJobPerm(a.restricted.jobPermission)) ||
				(permType == "laptopPermission" && hasPhonePerm(a.name, a.restricted.laptopPermission)) ||
				(permType == "reputation" && hasRep(a.restricted.reputation, a.restricted.reputationAmount || 0))) {
					return true;
				} else {
					return false;
				}
			})) {
				avail[a.name] = a;
			}
		} else {
			avail[a.name] = a;
		}

		if (
			!a.restricted ||
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
				))
		) {
			avail[a.name] = a;
		}
	});
	return avail;
};

import { useSelector } from 'react-redux';

export default () => {
	const myGovJob = useSelector(state => state.app.govJob);
	return (job, workplace = null, grade = null, gradeLevel = null) => {
		if (Boolean(job) && Boolean(myGovJob)) {
			if (myGovJob?.Id == job) {
				if (!workplace || (workplace && myGovJob?.Workplace?.Id == workplace)) {
					if (!grade || (grade && myGovJob?.Grade?.Id == grade)) {
						if (!gradeLevel || (gradeLevel && myGovJob?.Grade?.Level >= gradeLevel)) {
							return true;
						}
					}
				}
			}
		}
		return false;
	};
};

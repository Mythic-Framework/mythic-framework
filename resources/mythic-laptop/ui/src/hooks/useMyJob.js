import { useSelector } from 'react-redux';

export default () => {
	const myJobs = useSelector((state) => state.data.data.player?.Jobs);
	return (jobs, workplaces = null, grades = null) => {
		if (Boolean(jobs) && Boolean(myJobs)) {
			for (const myJob of myJobs) {
				if (Boolean(workplaces)) {
					if (Boolean(grades)) {
						if (
							jobs[myJob.Id] &&
							workplaces[myJob.Workplace?.Id] &&
							grades[myJob.Grade.Id]
						) return true;
					} else {
						if (jobs[myJob.Id] && workplaces[myJob.Workplace?.Id]) {
							return true;
						}
					}
				} else {
					if (Boolean(grades)) {
						if (
							jobs[myJob.Id] &&
							grades[myJob.Grade.Id]
						) return true;
					} else {
						if (jobs[myJob.Id]) {
							return true; 
						}
					}
				}
			}
		}
		return false;
	};
};

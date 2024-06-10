import { useSelector } from 'react-redux';

export default () => {
	const upgrades = useSelector((state) => state.data.data.companyUpgrades);
	const JobData = useSelector((state) => state.data.data.JobData);
	return (upgrade) => {
		return false;
	};
};

import { useSelector } from 'react-redux';

export default () => {
	const user = useSelector((state) => state.app.user);
	return (qualification) => {
		if (Boolean(user) && Boolean(qualification)) {
			return Boolean(user.Qualifications) && user.Qualifications.includes(qualification);
		}
	};
};

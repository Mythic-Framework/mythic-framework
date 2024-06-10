import { useSelector } from 'react-redux';

export default () => {
	const user = useSelector(state => state.app.user);
	return (first, last, callsign = false, SID, displaySID = false, displayNameForSelf = true, showFullName = false) => {
        if (!first || !last) return 'Unknown';

        const isSelf = SID === user.SID;
        if (isSelf && !displayNameForSelf) return 'You';

        let value = '';
        if (callsign) {
            value = `(${callsign}) ${showFullName ? first : `${first[0]}.`} ${last}`;
        } else {
            value = `${showFullName ? first : `${first[0]}.`} ${last}`;
        }

        if (SID && displaySID) value += ` [${SID}]`;
        if (isSelf) value += ' (You)';
        return value;
	};
};

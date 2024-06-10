import React, { useEffect } from 'react';
import { useHistory } from 'react-router-dom';
import { makeStyles } from '@material-ui/styles';

const useStyles = makeStyles((theme) => ({
	phoneVers: {
		height: 40,
		lineHeight: '40px',
		textAlign: 'center',
		fontFamily: 'Aclonica',
		width: '100%',
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
}));

export default (props) => {
	const classes = useStyles();
	const history = useHistory();

	useEffect(() => {
		return () => {
			clearTimeout(clickHoldTimer);
		};
	}, []);

	let clickHoldTimer = null;
	const versionStart = () => {
		clickHoldTimer = setTimeout(() => {
			history.push(`/apps/settings/software`);
		}, 2000);
	};

	const versionEnd = () => {
		clearTimeout(clickHoldTimer);
	};

	return (
		<div
			className={classes.phoneVers}
			onMouseDown={versionStart}
			onMouseUp={versionEnd}
			onMouseLeave={versionEnd}
		>
			Angry Boi OS <small>v{__APPVERSION__}</small>
		</div>
	);
};

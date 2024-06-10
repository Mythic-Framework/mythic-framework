import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Email from './Email';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflowY: 'auto',
		overflowX: 'hidden',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
    emptyMsg: {
        width: '100%',
        textAlign: 'center',
        fontSize: 20,
        fontWeight: 'bold',
        marginTop: '25%',
    }
}));

export default connect()((props) => {
	const classes = useStyles();
	const emails = useSelector((state) => state.data.data.emails);

	return (
		<div className={classes.wrapper}>
			{emails.length > 0 ? (
				emails
					.sort((a, b) => b.time - a.time)
					.map((email, index) => {
						return <Email key={`email-${index}`} email={email} />;
					})
			) : (
                <div className={classes.emptyMsg}>You Have No Emails</div>
			)}
		</div>
	);
});

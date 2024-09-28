import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import {
	Grid,
    TextField,
    Button,
    Avatar,
	Alert,
} from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../../util/Nui';
import { useAlert } from '../../../hooks';
import { Loader } from '../../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
        height: '100%',
	},
    editField: {
		marginBottom: 15,
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: '#1de9b6',
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
    preview: {
		width: 200,
		margin: 'auto',
		display: 'block',
	},
    button: {
        
    }
}));

export default ({ onNav }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
    const showAlert = useAlert();

    const [loading, setLoading] = useState(false);
    const [pfp, setPfp] = useState('');
    const onStateChange = (e) => {
        setPfp(e.target.value);
	};

    const fetch = async () => {
		setLoading(true);

		try {
			let res = await (
				await Nui.send('GetBusinessTwitter', {})
			).json();
			if (res?.success) {
				setPfp(res.pfp ?? "");
                setLoading(false);
			} else throw res;
		} catch (err) {
			console.log(err);
		}
	};

    useEffect(() => {
		fetch();
	}, []);

    const onUpdate = async () => {
        setLoading(true);

		try {
			let res = await (await Nui.send('SetBusinessTwitter', {
                profile: pfp,
            })).json();

			if (res) {
				setPfp(res);
                showAlert("Business Twitter Profile Updated");
			} else {
				setPfp('');
                showAlert("Failed to Update Business Twitter Profle");
			}
		} catch (err) {
			console.log(err);
		}

        setLoading(false);
	};

	return (
		<div className={classes.wrapper}>
            {loading ? (
                <Loader text="Loading" />
            ) : (
                <Grid container spacing={1}>
					<Grid item xs={12}>
						<Alert severity="info">Please use for business purposes only. Abuse of this will have your business permanently banned from using Twitter.</Alert>
					</Grid>
                    <Grid item xs={1}>
                        <Avatar
                            className={classes.avatar}
                            src={pfp}
                        />
                    </Grid>
                    <Grid item xs={11}>
                        <TextField
                            className={classes.editField}
                            label="Business Profile Picture"
                            name="tweet"
                            type="text"
                            fullWidth
                            required
                            value={pfp}
                            onChange={onStateChange}
                        />
                    </Grid>
                    <Grid item xs={12}>
                        <Button variant="outlined" fullWidth onClick={onUpdate}>
                            Update Profile
                        </Button>
                    </Grid>
                </Grid>
            )}
		</div>
	);
};
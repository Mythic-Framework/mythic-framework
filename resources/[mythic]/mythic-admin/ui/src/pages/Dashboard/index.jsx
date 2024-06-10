import React, { useEffect} from 'react';
import { Grid } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { useDispatch, useSelector } from 'react-redux';

//import { NoticeBoard } from '../../components';
import PlayerCountHistory from './PlayerCountHistory';
import PlayerCount from './PlayerCount';

import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '100%',
	},
	penis: {
		height: '50%',
	},
	dicks: {
		height: '100%',
	}
}));

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();

	const pData = useSelector(state => state.data.data.playerHistory);

	useEffect(() => {
        fetch();
		let interval = setInterval(() => fetch(), 60 * 1000);

        return () => {
            clearInterval(interval);
        }
	}, []);

	const fetch = async () => {
        try {
            let res = await(await Nui.send('GetPlayerHistory', {})).json();
            if (res) {
				dispatch({
					type: 'SET_DATA',
					payload: {
						type: 'playerHistory',
						data: res,
					}
				});
			}
        } catch(e) {

        };
    }

	return (
		<div className={classes.wrapper}>
			<Grid container spacing={4} style={{ height: '100%' }}>
				<Grid item xs={12} style={{ height: '35%' }}>
					<PlayerCount players={pData?.current ?? 0} max={pData?.max ?? 0} queue={pData?.queue ?? 0} />
				</Grid>
				<Grid item xs={12} style={{ height: '65%' }}>
					<PlayerCountHistory current={pData?.current ?? 0} history={pData?.history} />
				</Grid>
			</Grid>
		</div>
	);
};
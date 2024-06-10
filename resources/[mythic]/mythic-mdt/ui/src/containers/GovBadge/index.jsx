import React from 'react';
import { useSelector } from 'react-redux';
import {
	Grid,
    Fade,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import badgeHolder from '../../assets/img/badge_background.png';

import Badge from './Badge';
import Information from './Information';
import License from './License';

export default () => {
    const mdtHidden = useSelector(state => state.app.hidden);
	const showing = useSelector((state) => state.badge.showing);

    const type = useSelector(state => state.badge.type);
    const data = useSelector((state) => state.badge.data);
	const useStyles = makeStyles((theme) => ({
        container: {
            height: 600,
            width: 900,
            position: 'fixed',
            top: 0,
            bottom: 0,
            left: 0,
            //right: 0,
            margin: 'auto',
            overflow: 'hidden',
            zoom: '70%',
            userSelect: 'none',
		},
        backgroundImg: {
            zIndex: -1,
			background: `transparent no-repeat center`,
			height: '100%',
			width: '100%',
			position: 'absolute',
			pointerEvents: 'none',
			userSelect: 'none',
			right: 1,
        },
        inner: {
			height: '100%',
			width: '100%',
			padding: '45px',
			overflow: 'hidden',
        },
        content: {
            margin: 0,
            height: '100%',
            width: '100%',
        },
        fullHeight: {
            height: '100%',
        }
	}));

	const classes = useStyles();

	return (
        <Fade in={showing && mdtHidden}>
            {type === 1 ? (
                <div className={classes.container}>
                    <img className={classes.backgroundImg} src={badgeHolder} />
                    <div className={classes.inner}>
                        <Grid container className={classes.content}>
                            <Grid item xs={6} className={classes.fullHeight} style={{ paddingRight: '5%' }}>
                                <Information data={data} />
                            </Grid>
                            <Grid item xs={6} className={classes.fullHeight} style={{ paddingLeft: '5%' }}>
                                <Badge badge={data?.Department} />
                            </Grid>
                        </Grid>
                    </div>
                </div>
            ) : (
                <div className={classes.container}>
                    <div className={classes.inner}>
                        <License data={data} />
                    </div>
                </div>
            )}
        </Fade>
	);
};

import React from 'react';
import { useSelector } from 'react-redux';
import {
	Grid,
    Avatar
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import Moment from 'react-moment';

import Seal from '../../assets/img/seals/seal.webp';
import Card from '../../assets/img/card.png';

export default ({ data }) => {
    const useStyles = makeStyles((theme) => ({
        container: {
            //position: 'fixed',
            top: 0,
            bottom: 0,
            left: 0,
            width: 450,
            height: 250,
            background: '#2d4c5f',
            padding: '2.5% 1%',
            margin: 0,
            overflow: 'hidden',
            borderRadius: '5px',
            backgroundImage: `url(${Card})`,
            backgroundRepeat: 'no-repeat',
            backgroundSize: 'fit',
            backgroundPosition: 'center center'
        },
        titleContainer: {
            width: '100%',
            height: '20%',
        },
        licenseData: {
            width: '100%',
            height: '80%',
        },
        image: {
            width: '100%',
            margin: 'auto',
        },
        infoPane: {
            width: '100%',
            height: '100%',
        },
        fullHeight: {
            height: '100%',
        },
        avatarContainer: {
            padding: '15px',
        },
        avatar: {
            height: 125,
            width: 125,
            margin: 'auto',
        },
        bannerText: {
            width: '100%',
            color: theme.palette.text.main,
            textAlign: 'center',
            fontSize: 24,
            margin: 0,
            whiteSpace: 'pre-wrap',
        },
        titleText: {
            color: theme.palette.text.main,
            textAlign: 'center',
            fontSize: 34,
            fontWeight: 700,
            margin: 'auto',
        },
        infoText: {
            color: theme.palette.text.main,
            textAlign: 'center',
            fontSize: 24,
            margin: 0,
        },
        callsignText: {
            color: theme.palette.text.dark,
            textAlign: 'center',
            textTransform: 'capitalize',
            fontSize: 22,
            fontWeight: 700,
            margin: 0,
        },
    }));

    const classes = useStyles();

	return (
		<div className={classes.container}>
            <div className={classes.titleContainer}>
                <p className={classes.titleText}>San Andreas ID Card</p>
            </div>
            <Grid container className={classes.licenseData}>
                <Grid item xs={4} className={classes.avatarContainer}>
                    <Avatar
                        className={classes.avatar}
                        src={data?.Mugshot}
                    />
                </Grid>
                <Grid item xs={8} style={{ padding: '2.5%' }}>
                    <p className={classes.infoText}>Name: {data?.Name}</p>
                    <p className={classes.infoText}>State ID: {data?.SID}</p>
                    <p className={classes.infoText}>DOB: <Moment unix format={'ll'}>{data?.DOB}</Moment></p>
                    <p className={classes.infoText}>Expires: Oct 1, 2026</p>
                </Grid>
            </Grid>
		</div>
	);
};
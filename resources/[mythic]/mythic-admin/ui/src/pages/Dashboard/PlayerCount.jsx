import React from 'react';
import { Grid, Card, CardContent, Divider, Avatar, Box, LinearProgress } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
	},
    card: {
        textAlign: 'center',
    },
    statLabel: {
        fontSize: 16,
        color: theme.palette.grey[500],
        fontWeight: 500,
        margin: 0,
    },
    statValue: {
        fontSize: 24,
        fontWeight: 'bold',
        marginBottom: 4,
        letterSpacing: '1px',
    },
}));

export default ({ players, max, queue }) => {
	const classes = useStyles();

	return (
        <Card className={classes.card} variant="outlined">
            <Box display={'flex'}>
                <Box p={2} flex={'auto'}>
                    <p className={classes.statLabel}>Online Players</p>
                    <p className={classes.statValue}>{players}</p>
                </Box>
                <Box p={2} flex={'auto'}>
                    <p className={classes.statLabel}>Players in Queue</p>
                    <p className={classes.statValue}>{queue}</p>
                </Box>
            </Box>
            <Divider light />
            <CardContent style={{ padding: 23 }}>
                <LinearProgress variant="determinate" value={Math.floor((players / max) * 100)} />
            </CardContent>
        </Card>
	);
};
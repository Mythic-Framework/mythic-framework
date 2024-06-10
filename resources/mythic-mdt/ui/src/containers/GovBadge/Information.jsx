import React from 'react';
import { useSelector } from 'react-redux';
import {
	Grid,
    Avatar
} from '@mui/material';
import { makeStyles } from '@mui/styles';

const DepartmentData = {
    lspd: {
        name: 'Los Santos\n Police Department',
        color: '#2a4179',
    },
    lscso: {
        name: 'Blaine County\n Sheriff\'s Office',
        color: '#755613',
    },
    sasp: {
        name: 'San Andreas Highway Patrol',
        color: '#C0C0C0',
    },
    safd: {
        name: 'San Andreas Medical Services',
        color: '#5271ff',
    },
    doj: {
        name: 'San Andreas\n Department of Justice',
        color: '#452f00',
    },
    dattorney: {
        name: 'District Attorney\'s Office',
        color: '#452f00',
    },
    publicdefenders: {
        name: 'Public Defenders Office',
        color: '#452f00',
    },
}

export default ({ data }) => {
    const useStyles = makeStyles((theme) => ({
        container: {
            width: '100%',
            height: '100%',
            padding: '5%',
        },
        infoPane: {
            width: '100%',
            height: '100%',
            background: '#EBEBEB',
            borderRadius: '10px',
        },
        fullHeight: {
            height: '100%',
        },
        avatarContainer: {
            padding: '15px',
        },
        avatar: {
            height: 175,
            width: 175,
            margin: 'auto',
        },
        departmentBanner: {
            height: '100%',
            width: '100%',
            background: DepartmentData[data?.Department]?.color ?? '#452f00',
            padding: '5px 15px',
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
            color: theme.palette.text.dark,
            textAlign: 'center',
            textTransform: 'capitalize',
            fontSize: 34,
            fontWeight: 700,
            margin: 0,
        },
        nameText: {
            color: theme.palette.text.dark,
            textAlign: 'center',
            textTransform: 'capitalize',
            fontSize: 28,
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
            <div className={classes.infoPane}>
                <Grid container direction="column" className={classes.fullHeight}>
                    <Grid item xs={5} className={classes.avatarContainer}>
                        <Avatar
                            className={classes.avatar}
                            src={data?.Mugshot}
                        />
                    </Grid>
                    <Grid item xs={2} className={classes.departmentBanner}>
                        <p className={classes.bannerText}>{DepartmentData[data?.Department]?.name ?? 'San Andreas Government'}</p>
                    </Grid>
                    <Grid item xs={4} style={{ padding: '15px', overflow: 'none' }}>
                        <p className={classes.titleText}>{data?.Title}</p>
                        <p className={classes.nameText}>{data?.First?.[0]?.toUpperCase()}. {data?.Last?.substr(0, 16)}</p>
                        {data?.Callsign && <p className={classes.callsignText}>#{data?.Callsign}</p>}
                        <p className={classes.callsignText} style={{ fontSize: 18 }}>State ID: {data?.SID}</p>
                    </Grid>
                </Grid>
            </div>
        </div>
	);
};

import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { List } from '@material-ui/core';

import Document from './Document';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	status: {
		color: theme.palette.success.main,
		'&::before': {
			content: '" - "',
            color: theme.palette.text.main,
		},
		'&.spawned': {
			color: theme.palette.error.main,
		},
	},
    emptyMsg: {
        width: '100%',
        textAlign: 'center',
        fontSize: 20,
        fontWeight: 'bold',
        marginTop: '25%',
    },
    list: {
		height: '95%',
		//overflow: 'auto',
		overflowX: 'hidden',
		overflowY: 'auto',
	}
}));

export default ({ documents, showShared }) => {
	const classes = useStyles();
    const player = useSelector((state) => state.data.data.player);

    const filteredDocuments = documents.filter(d => {
        if (showShared) {
            if (d.shared) {
                return true;
            } else {
                return (d.owner != player.ID);
            }
        } else {
            if (!d.shared) {
                return d.owner == player.ID;
            }
        }

        return false;
    })

    if (filteredDocuments.length > 0) {
        return (<List className={classes.list}>
            {filteredDocuments.sort((a, b) => b.time - a.time).map((doc, k) => {
                return <Document key={doc._id} document={doc} />;
            })}
        </List>)
    } else {
        return <div className={classes.emptyMsg}>{showShared ? 'No Documents Shared With You' : 'No Saved Documents'}</div>
    }
};
import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import { Chip, } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { usePermissions } from '../../../../hooks';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
    item: {
        transition: 'background ease-in 0.15s',
		border: `1px solid ${theme.palette.border.divider}`,
		margin: 7.5,
        transition: 'filter ease-in 0.15s',
        '&:hover': {
			filter: 'brightness(0.8)',
			cursor: 'pointer',
		},
    }
}));

export default ({ tag, ignorePermissions = false, ...rest }) => {
	const classes = useStyles();
    const hasPermission = usePermissions();
    const govJob = useSelector(state => state.app.govJob);
    if (!tag) return null;

    let canEdit = !ignorePermissions ? hasPermission(tag?.requiredPermission) : true;
    if (tag?.requiredPermission === "ATTORNEY_PENDING_EVIDENCE" && (govJob?.Id === "police" || govJob?.Id === "government")) {
        canEdit = true;
    };

	return (
        <Chip
            {...rest}
            disabled={!canEdit}
            className={classes.item}
            style={tag?.style}
            label={tag?.name || 'Tag'}
            icon={(!ignorePermissions && tag?.restrictViewing) ? <FontAwesomeIcon icon={['fas', 'lock-keyhole']}/> : null}
        />
	);
};
import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { ListItem, ListItemText } from '@material-ui/core';
import { Link } from 'react-router-dom';
import Moment from 'react-moment';

const useStyles = makeStyles((theme) => ({

}));

export default ({ document }) => {
	const classes = useStyles();

	return (
		<ListItem
			divider
			button
			component={Link}
			to={`/apps/documents/view/${document._id}/v`}
		>
			<ListItemText
				primary={`${document.title}`}
				secondary={
					<span>
                        Last Edited{' '}
                        <Moment unix fromNow>
                            {document.time}
                        </Moment>
					</span>
				}
			/>
		</ListItem>
	);
};

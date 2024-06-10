import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@material-ui/styles';
import { useHistory } from 'react-router-dom';
import { List, ListItem, ListItemText } from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import ChopItem from './component/ChopItem';
import { Modal } from '../../components';
import Moment from 'react-moment';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflow: 'auto',
	},
	header: {
		background: '#696969',
		fontSize: 20,
		padding: 15,
		lineHeight: '50px',
		height: 78,
	},
	content: {
		height: '83.5%',
		overflow: 'hidden',
	},
	headerAction: {},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	tabPanel: {
		top: 0,
		height: '97.5%',
	},
	list: {
		height: '100%',
		overflow: 'auto',
	},
	body: {
		padding: 10,
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default ({ chopList }) => {
	const classes = useStyles();

	const [open, setOpen] = useState(null);

	return (
		<div className={classes.wrapper}>
			<List className={classes.body}>
				{Object.keys(chopList).map((k) => {
					return (
						<ListItem
							key={`choplist-${k}`}
							button
							divider
							onClick={() => setOpen(k)}
						>
							<ListItemText
								primary={
									Boolean(chopList[k]?.id)
										? k
										: `${k} Chop List`
								}
								secondary={
									<>
										{Boolean(chopList[k].public) ? (
											<span>
												Shared Chop List -{' '}
												{chopList[k].list.length}{' '}
												Remaining
												{chopList[k].list.length > 1
													? ' Vehicles'
													: ' Vehicle'}
											</span>
										) : Boolean(chopList[k].id) ? (
											<span>
												Personal Chop List -{' '}
												{chopList[k].list.length}{' '}
												Remaining
												{chopList[k].list.length > 1
													? ' Vehicles'
													: ' Vehicle'}
											</span>
										) : null}
									</>
								}
							/>
						</ListItem>
					);
				})}
			</List>
			{Boolean(open) && (
				<Modal
					open={Boolean(open)}
					title={`${open} Chop List`}
					closeLang="Close"
					maxWidth="xs"
					onClose={() => setOpen(null)}
				>
					{chopList[open].list
						.sort((a, b) => b.hv - a.hv)
						.map((chop, index) => {
							return (
								<ChopItem
									key={`chopitem-${index}`}
									chopRequest={chop}
								/>
							);
						})}
				</Modal>
			)}
		</div>
	);
};

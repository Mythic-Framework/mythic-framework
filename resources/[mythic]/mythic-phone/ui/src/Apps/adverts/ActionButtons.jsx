import React, { useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { Fab } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useAlert } from '../../hooks';
import { DeleteAdvert, BumpAdvert } from './action';

const useStyles = makeStyles((theme) => ({
	add: {
		position: 'absolute',
		bottom: '12%',
		right: '10%',
		backgroundColor: '#f9a825',
		fontSize: 22,
		opacity: 0.3,
		'&:hover': {
			backgroundColor: '#f9a825',
			opacity: 1,
			transition: 'opacity ease-in 0.3s',
		},
	},
	delete: {
		position: 'absolute',
		bottom: '19%',
		right: '10%',
		backgroundColor: theme.palette.error.main,
		fontSize: 22,
		opacity: 0.3,
		'&:hover': {
			backgroundColor: theme.palette.error.main,
			opacity: 1,
			transition: 'opacity ease-in 0.3s',
		},
	},
	bump: {
		position: 'absolute',
		bottom: '26%',
		right: '10%',
		backgroundColor: theme.palette.error.light,
		fontSize: 22,
		opacity: 0.3,
		'&:hover': {
			backgroundColor: theme.palette.error.light,
			opacity: 1,
			transition: 'opacity ease-in 0.3s',
		},
	},
}));

export default connect(null, { DeleteAdvert, BumpAdvert })((props) => {
	const showAlert = useAlert();
	const classes = useStyles();
	const history = useHistory();
	const myAdvertId = useSelector((state) => state.data.data.player.Source);
	const myAdvert = useSelector((state) => state.data.data.adverts)[
		myAdvertId
	];

	const [del, setDel] = useState(false);
	const onDelete = () => {
		setDel(true);

		setTimeout(() => {
			props.DeleteAdvert(myAdvertId, () => {
				showAlert('Advertisement Deleted');
			});
		}, 500);
	};
	const onBump = () => {
		props.BumpAdvert(myAdvertId, myAdvert, () => {
			showAlert('Advertisement Bumped');
		});
	};

	return (
		<>
			{myAdvert != null && !del ? (
				<>
					<Fab
						className={classes.add}
						onClick={() => history.push('/apps/adverts/edit')}
					>
						<FontAwesomeIcon icon={['fas', 'pen-to-square']} />
					</Fab>
					<Fab
						className={classes.delete}
						onClick={onDelete}
						disabled={del}
					>
						<FontAwesomeIcon icon={['fas', 'trash']} />
					</Fab>
					{myAdvert.time < Date.now() - 1000 * 60 * 30 ? (
						<Fab className={classes.bump} onClick={onBump}>
							<FontAwesomeIcon icon={['fas', 'upload']} />
						</Fab>
					) : null}
				</>
			) : (
				<Fab
					className={classes.add}
					onClick={() => history.push('/apps/adverts/add')}
				>
					<FontAwesomeIcon icon={['fas', 'plus']} />
				</Fab>
			)}
		</>
	);
});

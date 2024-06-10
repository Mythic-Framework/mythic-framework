import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { Grid, Paper, Chip } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import Moment from 'react-moment';
import NumberFormat from 'react-number-format';

import { Categories } from '../data';
import { DeleteAdvert } from '../action';

const useStyles = makeStyles((theme) => ({
	convo: {
		'&::before': {
			background: 'transparent !important',
		},
		width: '95%',
		background: theme.palette.secondary.dark,
		padding: '10px 12px 0 12px',
		margin: '2px 0',
		transition: 'background 400ms',
		'&:hover': {
			background: theme.palette.secondary.main,
			transition: 'background ease-in 0.15s',
			cursor: 'pointer',
		},
		margin: '2.5% auto',
	},
	title: {
		fontSize: 22,
		color: '#f9a825',
	},
	time: {
		fontSize: 12,
		color: theme.palette.text.main,
		float: 'right',
		lineHeight: '25px',
	},
	desc: {
		fontSize: 16,
		color: theme.palette.text.light,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		padding: 5,
	},
	categories: {
		display: 'flex',
		justifyContent: 'flex-start',
		flexWrap: 'wrap',
		'& > *': {
			margin: theme.spacing(0.5),
		},
	},
	yours: {
		color: '#f9a825',
		fontSize: 10,
		marginRight: 5,
	},
	authorPane: {
		borderTop: '1px solid #f9a825',
		marginTop: 10,
	},
	author: {
		position: 'absolute',
		width: 'fit-content',
		height: 'fit-content',
		top: 0,
		bottom: 0,
		right: '1%',
		margin: 'auto',
		fontSize: 12,
		color: theme.palette.text.main,
	},
	price: {
		textAlign: 'left',
		padding: 5,
	},
	priceValue: {
		'&::before': {
			content: '"$"',
			color: theme.palette.success.main,
			marginRight: 2,
		},
		fontSize: 20,
	},
	noprice: {
		textAlign: 'left',
		fontSize: 18,
	},
	postedTime: {
		fontSize: 14,
		color: '#f9a825',
	},
}));

export default connect(null, { DeleteAdvert })((props) => {
	const classes = useStyles();
	const history = useHistory();
	const myId = useSelector((state) => state.data.data.player.Source);
	const cats = Categories.filter((cat) => {
		return props.advert.categories.includes(cat.label);
	});

	const onClick = () => {
		history.push(`/apps/adverts/view/${props.advert.id}`);
	};

	return (
		<Paper className={classes.convo} onClick={onClick}>
			<Grid container>
				<Grid item xs={12} style={{ position: 'relative' }}>
					<div>
						<span className={classes.title}>
							{props.advert.title}{' '}
						</span>
					</div>
					<div className={classes.desc}>{props.advert.short}</div>
					<div>
						{props.advert.price != null &&
						props.advert.price !== '' ? (
							<div className={classes.price}>
								<NumberFormat
									className={classes.priceValue}
									value={props.advert.price}
									displayType={'text'}
									thousandSeparator={true}
								/>
							</div>
						) : (
							<div className={classes.noprice}>
								Price Negotiable
							</div>
						)}
					</div>
					<div className={classes.categories}>
						{cats.map((cat, i) => {
							return (
								<Chip
									key={`advert-cat-${i}`}
									size="small"
									style={{ backgroundColor: cat.color }}
									label={cat.label}
								/>
							);
						})}
					</div>
				</Grid>
				<Grid item xs={12} className={classes.authorPane}>
					<Grid container style={{ height: 40, padding: '0 5px' }}>
						<Grid
							item
							xs={5}
							style={{ textAlign: 'left', lineHeight: '40px' }}
						>
							<Moment
								className={classes.postedTime}
								interval={60000}
								fromNow
								date={+props.advert.time}
							/>
						</Grid>
						<Grid
							item
							xs={7}
							style={{ textAlign: 'right', lineHeight: '40px' }}
						>
							{props.advert.id === myId ? (
								<span className={classes.yours}>(Your Ad)</span>
							) : null}
							{props.advert.author}
						</Grid>
					</Grid>
				</Grid>
			</Grid>
		</Paper>
	);
});

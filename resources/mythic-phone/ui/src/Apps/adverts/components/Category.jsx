import React from 'react';
import { connect, useSelector } from 'react-redux';
import { Grid, IconButton, Zoom } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useHistory } from 'react-router-dom';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: 'fit-content',
		background: theme.palette.secondary.main,
		marginBottom: 10,
	},
	header: {
		width: '100%',
		padding: 10,
		fontSize: 20,
		height: 50,
		borderBottom: `1px solid ${theme.palette.text.main}`,
	},
	title: {
		width: 'fit-content',
		height: 'fit-content',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		margin: 'auto',
	},
	btn: {
		width: 'fit-content',
		height: 'fit-content',
		position: 'absolute',
		top: 0,
		bottom: 0,
		right: 0,
		margin: 'auto',
	},
	none: {
		padding: 25,
		fontSize: 18,
		fontWeight: 'bold',
	},
}));

export default connect()((props) => {
	const classes = useStyles();
	const history = useHistory();
	const adObjs = useSelector((state) => state.data.data.adverts);

	const adverts = Object.keys(adObjs).filter(a => a !== '0').filter((ad) => {
		return adObjs[ad].categories.includes(props.category.label);
	});

	const onClick = () => {
		history.push(`/apps/adverts/category-view/${props.category.label}`);
	}

	return (
		<Zoom in={true} duration={1000}>
			<div
				className={classes.wrapper}
				style={{ backgroundColor: props.category.color }}
			>
				<Grid container className={classes.header}>
					<Grid item xs={12} style={{ position: 'relative' }}>
						<div className={classes.title}>
							{props.category.label}
						</div>
					</Grid>
				</Grid>
				<Grid container className={classes.body}>
					<Grid item xs={10} style={{ position: 'relative' }}>
						{adverts.length > 0 ? (
							<div className={classes.none}>{`${adverts.length} ${
								adverts.length > 1
									? 'Advertisements'
									: 'Advertisement'
							}`}</div>
						) : (
							<div className={classes.none}>
								No Advertisements In This Category
							</div>
						)}
					</Grid>
					<Grid item xs={2} style={{ position: 'relative' }}>
						<IconButton className={classes.btn} onClick={onClick}>
							<FontAwesomeIcon icon={['fas', 'chevron-right']} />
						</IconButton>
					</Grid>
				</Grid>
			</div>
		</Zoom>
	);
});

import React, { useState } from 'react';
import {
	Grid,
	Fade,
	Avatar,
	Button,
	Paper,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	div: {
		width: '100%',
		textDecoration: 'none',
		whiteSpace: 'nowrap',
		verticalAlign: 'middle',
		userSelect: 'none',
		'-webkit-user-select': 'none',
		position: 'relative',
	},
	rowWrapper: {
		background: theme.palette.secondary.main,
		padding: '25px 12px',
		width: '100%',
		height: 'fit-content',
		userSelect: 'none',
		'-webkit-user-select': 'none',
		'&:hover': {
			background: theme.palette.secondary.light,
			transition: 'background ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	rowWrapperActive: {
		background: theme.palette.secondary.light,
		padding: '25px 12px',
		width: '100%',
		height: 'fit-content',
		userSelect: 'none',
		'-webkit-user-select': 'none',
		'&:hover': {
			background: theme.palette.secondary.light,
			transition: 'background ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	avatar: {
		color: theme.palette.text.light,
		height: 55,
		width: 55,
		fontSize: 35,
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
	avatarIcon: {
		fontSize: 35,
	},
	sectionHeader: {
		display: 'block',
		fontSize: 20,
		fontWeight: 'bold',
		lineHeight: '35px',
	},
	popup: {
		opacity: 1,
		transition: 'opacity 0.15s',
		position: 'absolute',
		left: 0,
		right: 0,
		top: '90%',
		zIndex: '2',
		margin: 0,
	},
	cover: {
		position: 'fixed',
		top: '0px',
		right: '0px',
		bottom: '0px',
		left: '0px',
		zIndex: -1,
	},
	itemsList: {
		width: '100%',
		background: theme.palette.secondary.light,
		minHeight: 84,
		zIndex: 999,
	},
	arrow: {
		fontSize: 25,
		position: 'absolute',
		top: 0,
		bottom: 0,
		right: 0,
		left: 0,
		margin: 'auto',
	},
	selectOption: {
		padding: 10,
		background: theme.palette.secondary.light,
		lineHeight: '50px',
		fontSize: 20,
		fontWeight: 'bold',
		'&:hover': {
			filter: 'brightness(0.7)',
			transition: 'filter ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	selectedOption: {
		padding: 10,
		background: theme.palette.secondary.light,
		lineHeight: '50px',
		fontSize: 20,
		fontWeight: 'bold',
		border: `1px solid ${theme.palette.primary.main}`,
		'&:hover': {
			filter: 'brightness(0.7)',
			transition: 'filter ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	playBtn: {
		textAlign: 'center',
		fontSize: 20,
		lineHeight: '50px',
		fontWeight: 'bold',
		position: 'relative',
	},
	selectedItem: {
		color: theme.palette.text.main,
		fontWeight: 'bold',
	},
}));

export default (props) => {
	const classes = useStyles();
	const [showList, setShowList] = useState(false);
	const [selected, setSelected] = useState(props.selected);

	const onClick = () => {
		if (!props.disabled) {
			setShowList(!showList);
		}
	};

	const changeSelected = (index) => {
		onClick();
		setSelected(index);
		props.onChange(index);
	};

	const cssClass = props.disabled ? `${classes.div} disabled` : classes.div;
	const style = props.disabled ? { opacity: 0.5 } : {};

	return (
		<div className={cssClass} style={style}>
			<Grid container>
				<Paper
					className={
						showList ? classes.rowWrapperActive : classes.rowWrapper
					}
					onClick={onClick}
				>
					<Grid item xs={12}>
						<Grid container>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<Avatar
									className={classes.avatar}
									style={{ backgroundColor: props.color }}
								>
									<FontAwesomeIcon
										icon={['fas', 'music-note']}
										className={classes.avatarIcon}
									/>
								</Avatar>
							</Grid>
							<Grid
								item
								xs={8}
								style={{ paddingLeft: 5, position: 'relative' }}
							>
								<span className={classes.sectionHeader}>
									{props.label}
								</span>
								<span className={classes.selectedItem}>
									{
										props.options.filter(
											(i) => i.value === selected,
										)[0].label
									}
								</span>
							</Grid>
							<Grid item xs={2} style={{ position: 'relative' }}>
								{showList ? (
									<FontAwesomeIcon
										icon={['fas', 'chevron-up']}
										className={classes.arrow}
									/>
								) : (
									<FontAwesomeIcon
										icon={['fas', 'chevron-down']}
										className={classes.arrow}
									/>
								)}
							</Grid>
						</Grid>
					</Grid>
				</Paper>
			</Grid>
			<Fade in={showList}>
				<Paper className={classes.popup}>
					<div className={classes.cover} onClick={onClick} />
					<div className={classes.itemsList}>
						{props.options.map(function (item, i) {
							return (
								<Paper
									key={`${props.label}-${i}`}
									className={
										i === selected
											? classes.selectedOption
											: classes.selectOption
									}
								>
									<Grid
										container
										style={{ padding: '0 10px' }}
									>
										<Grid
											item
											xs={10}
											onClick={() => {
												changeSelected(item.value);
											}}
										>
											{item.label}
										</Grid>
										<Grid
											item
											xs={2}
											className={classes.playBtn}
											onClick={() => {
												props.playSound(item.value);
											}}
										>
											<Button
												className={classes.arrow}
												variant="outlined"
											>
												<FontAwesomeIcon
													icon={['fas', 'play']}
													className={classes.arrow}
												/>
											</Button>
										</Grid>
									</Grid>
								</Paper>
							);
						})}
					</div>
				</Paper>
			</Fade>
		</div>
	);
};

import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import {
	Grid,
	Avatar,
	Paper,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Modal, ColorPicker } from '../../../components';

const useStyles = makeStyles((theme) => ({
	div: {
		width: '100%',
		textDecoration: 'none',
		whiteSpace: 'nowrap',
		verticalAlign: 'middle',
		userSelect: 'none',
		'-webkit-user-select': 'none',
		textAlign: 'left',
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
	avatar: {
		color: theme.palette.text.dark,
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
		color: theme.palette.text.light,
	},
	sectionHeader: {
		display: 'block',
		fontSize: 20,
		fontWeight: 'bold',
		lineHeight: '35px',
	},
	arrow: {
		fontSize: 35,
		position: 'absolute',
		top: 0,
		bottom: 0,
		right: 0,
		margin: 'auto',
	},
	selectedItem: {
		color: theme.palette.text.main,
		fontWeight: 'bold',
	},
}));

export default (props) => {
	const classes = useStyles();
	const settings = useSelector(
		(state) => state.data.data.player.PhoneSettings,
	);
	const [open, setOpen] = useState(false);
	const [color, setColor] = useState(props.color);

	const onClick = () => {
		setOpen(!open);
	};

	const onChange = (e) => {
		setColor(e.hex);
	};

	const onSave = (index) => {
		onClick();
		props.onSave(color);
	};

	const cssClass = props.disabled ? `${classes.div} disabled` : classes.div;
	const style = props.disabled ? { opacity: 0.5 } : {};

	return (
		<div className={cssClass} style={style}>
			<Grid container>
				<Paper className={classes.rowWrapper} onClick={onClick}>
					<Grid item xs={12}>
						<Grid container>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<Avatar
									className={classes.avatar}
									style={{ backgroundColor: props.color }}
								>
									<FontAwesomeIcon
										icon={['fas', 'eye-dropper-half']}
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
								<span
									className={classes.selectedItem}
									style={{ color: props.color }}
								>
									{props.color}
								</span>
							</Grid>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<FontAwesomeIcon
									icon={['fas', 'chevron-right']}
									className={classes.arrow}
								/>
							</Grid>
						</Grid>
					</Grid>
				</Paper>
			</Grid>
			{open ? (
				<Modal
					open={open}
					title={`Select ${props.label}`}
					onClose={() => onClick(false)}
					onAccept={onSave}
					acceptLang="Save"
				>
					<ColorPicker color={color} onChange={onChange} />
				</Modal>
			) : null}
		</div>
	);
};

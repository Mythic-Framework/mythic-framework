import React, { useState } from 'react';
import { connect, useSelector } from 'react-redux';
import {
	TextField,
	ButtonGroup,
	Button,
	Chip,
	InputAdornment,
	Autocomplete,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { useHistory } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useAlert } from '../../hooks';
import { CreateAdvert } from './action';
import { Categories } from './data';
import { Editor } from '../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflowY: 'auto',
		overflowX: 'auto',
		padding: 10,
	},
	button: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.warning.main,
		'&:hover': {
			backgroundColor: `${theme.palette.warning.main}14`,
		},
	},
	buttonNegative: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.error.main,
		'&:hover': {
			backgroundColor: `${theme.palette.error.main}14`,
		},
	},
	buttonPositive: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.success.main,
		'&:hover': {
			backgroundColor: `${theme.palette.success.main}14`,
		},
	},
	creatorInput: {
		marginTop: 20,
	},
}));

const initState = {
	title: '',
	short: '',
	full: '',
	price: '',
	tags: Array(),
};

export default connect(null, { CreateAdvert })((props) => {
	const showAlert = useAlert();
	const classes = useStyles();
	const history = useHistory();
	const player = useSelector((state) => state.data.data.player);

	const [state, setState] = useState(initState);
	const onChange = (content) => {
		setState({
			...state,
			full: content,
		});
	};

	const textChange = (e) => {
		setState({
			...state,
			[e.target.name]: e.target.value,
		});
	};

	const onSave = () => {
		let t = Array();
		state.tags.map((tag) => {
			t.push(tag.label);
		});
		props.CreateAdvert(
			player.Source,
			{
				...state,
				id: player.Source,
				author: `${player.First} ${player.Last}`,
				number: player.Phone,
				time: Date.now(),
				categories: t,
			},
			() => {
				showAlert('Advert Created');
				history.goBack();
			},
		);
	};

	return (
		<div className={classes.wrapper}>
			<TextField
				fullWidth
				label="Title"
				name="title"
				variant="outlined"
				required
				onChange={textChange}
				value={state.title}
				inputProps={{
					maxLength: 32,
				}}
			/>
			<Autocomplete
				multiple
				fullWidth
				required
				style={{ marginTop: 10 }}
				value={state.tags}
				onChange={(event, newValue) => {
					setState({
						...state,
						tags: [...newValue],
					});
				}}
				options={Categories}
				getOptionLabel={(option) => option.label}
				renderTags={(tagValue, getTagProps) =>
					tagValue.map((option, index) => (
						<Chip
							label={option.label}
							style={{ backgroundColor: option.color }}
							{...getTagProps({ index })}
						/>
					))
				}
				renderInput={(params) => (
					<TextField {...params} label="Tags" variant="outlined" />
				)}
			/>
			<TextField
				className={classes.creatorInput}
				fullWidth
				label="Price (Leave Empty If Negotiable)"
				name="price"
				variant="outlined"
				onChange={textChange}
				value={state.price}
				inputProps={{
					maxLength: 16,
				}}
				InputProps={{
					startAdornment: (
						<InputAdornment position="start">
							<FontAwesomeIcon icon={['fas', 'dollar-sign']} />
						</InputAdornment>
					),
				}}
			/>
			<TextField
				className={classes.creatorInput}
				fullWidth
				label="Short Description"
				name="short"
				variant="outlined"
				required
				onChange={textChange}
				value={state.short}
				inputProps={{
					maxLength: 64,
				}}
			/>
			<Editor
				//minified
				value={state.full}
				onChange={onChange}
				placeholder="Description"
			/>
			<ButtonGroup variant="text" color="primary" fullWidth>
				<Button
					className={classes.buttonNegative}
					onClick={() => history.goBack()}
				>
					Cancel
				</Button>
				<Button className={classes.buttonPositive} onClick={onSave}>
					Post Ad
				</Button>
			</ButtonGroup>
		</div>
	);
});

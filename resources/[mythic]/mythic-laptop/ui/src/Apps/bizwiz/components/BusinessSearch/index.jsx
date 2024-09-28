import React, { useMemo, useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import {
	TextField,
	Autocomplete,
	Chip,
	ListItem,
	ListItemText,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import _, { throttle } from 'lodash';

import Nui from '../../../../util/Nui';

const useStyles = makeStyles((theme) => ({
	editorField: {
		marginBottom: 10,
	},
	option: {
		transition: 'background ease-in 0.15s',
		border: `1px solid ${theme.palette.border.divider}`,
		'&:hover': {
			background: theme.palette.secondary.main,
			cursor: 'pointer',
		},
		'&.selected': {
			color: theme.palette.primary.main,
		},
	},
}));

export default ({
	label,
	placeholder,
	value,
	inputValue,
	options,
	setOptions,
	onChange,
	onInputChange,
	disableSelf = true,
	job = 'pdm',
}) => {
	const classes = useStyles();
	const user = useSelector((state) => state.data.data.player);

	const fetch = useMemo(
		() =>
			throttle(async (job) => {
				try {
					let res = await (
						await Nui.send('BizWizEmployeeSearch', {
							job: job,
							//term: v,
						})
					).json();
					setOptions(res);
				} catch (err) {
					setOptions(Array());
				}
			}, 5000),
		[],
	);

	// useEffect(() => {
	// 	fetch(job);
	// }, [])

	useEffect(() => {
		fetch(job);
	}, [value, job]);

	return (
		<Autocomplete
			fullWidth
			multiple
			className={classes.editorField}
			getOptionLabel={(option) => {
				return `${option.First} ${option.Last} (${option.SID})`;
			}}
			// getOptionSelected={(option) =>
			// 	value.filter((v) => v.SID == option.SID).length > 0
			// }
			options={options.filter(o => !value.some(v => v.SID == o.SID))}
			autoComplete
			includeInputInList
			autoHighlight
			filterSelectedOptions
			value={value}
			onChange={onChange}
			onInputChange={onInputChange}
			renderInput={(params) => (
				<TextField
					{...params}
					name={label.toLowerCase()}
					placeholder={placeholder}
					label={label}
					fullWidth
				/>
			)}
			renderTags={(value, getTagProps) =>
				value.map((option, index) => {
					return (
						<Chip
							color={
								disableSelf && option.SID == user.SID
									? 'primary'
									: 'default'
							}
							variant="outlined"
							label={`${option.First} ${option.Last} (${option.SID})`}
							{...getTagProps({ index })}
							disabled={
								disableSelf && option.SID == user.SID
							}
						/>
					);
				})
			}
			renderOption={(props, option) => {
				if (disableSelf && option.SID == user.SID) {
					props.onClick = null;
				}

				return (
					<ListItem
						{...props}
						key={`${option.SID}`}
						className={classes.option}
						disabled={disableSelf && option.SID == user.SID}
					>
						<ListItemText
							primary={`${option.First} ${option.Last}`}
							secondary={`State ID: ${option.SID}`}
						/>
					</ListItem>
				);
			}}
		/>
	);
};

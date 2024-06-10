import React, { useMemo, useState, useEffect, useRef } from 'react';
import { useSelector } from 'react-redux';
import {
	TextField,
	Autocomplete,
	Chip,
	ListItem,
	ListItemText,
	InputAdornment,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import _, { debounce } from 'lodash';

import Nui from '../../util/Nui';

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
}) => {
	const classes = useStyles();
	const [loading, setLoading] = useState(false);

	const fetch = useMemo(
		() =>
			debounce(async (v) => {
				try {
					let res = await (
						await Nui.send('Search', {
							type: 'people',
							term: v,
						})
					).json();
					setOptions(res);
				} catch (err) {
					setOptions(Array());
				}
				setLoading(false);
			}, 1500),
		[],
	);

	useEffect(() => {
		if (inputValue && inputValue.length > 0) {
			setLoading(true);
			setOptions(Array());

			fetch(inputValue);
		} else {
			setLoading(false);
			setOptions(Array());
		}
	}, [value, inputValue]);

	return (
		<Autocomplete
			loading={loading}
			fullWidth
			multiple
			className={classes.editorField}
			getOptionLabel={(option) => {
				return `${option.First} ${option.Last} [${option.SID}]`;
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
							color="default"
							variant="outlined"
							label={`${option.First} ${option.Last} [${option.SID}]`}
							{...getTagProps({ index })}
						/>
					);
				})
			}
			renderOption={(props, option) => {
				return (
					<ListItem
						{...props}
						key={`${option.SID}`}
						className={classes.option}
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

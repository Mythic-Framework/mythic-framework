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
import TagItem from './TagItem';
import { usePermissions } from '../../../../hooks';

const useStyles = makeStyles((theme) => ({
	editorField: {
		marginBottom: 10,
	},
}));

export default ({
	label,
	value,
	inputValue,
	options,
	setOptions,
	onChange,
	onInputChange,
}) => {
	const classes = useStyles();
    const availableTags = useSelector(state => state.data.data.tags);
	const hasPermission = usePermissions();
	const govJob = useSelector(state => state.app.govJob);
	const [tags, setTags] = useState(Array());

	useEffect(() => {
        let rgx = new RegExp(inputValue, 'i');
        setOptions(availableTags.filter(t => {
			if (t.name.match(rgx)) {
				if (!t?.requiredPermission || hasPermission(t?.requiredPermission) || (t?.requiredPermission === "ATTORNEY_PENDING_EVIDENCE" && (govJob?.Id === "police" || govJob?.Id === "government"))) {
					return true;
				};
			}
			return false;
		}));
	}, [value, inputValue]);

	useEffect(() => {
		setTags(value.map(t => availableTags.find(tData => tData._id == t)));
	}, [value]);

	return (
		<Autocomplete
			fullWidth
			multiple
			className={classes.editorField}
			getOptionLabel={(option) => {
				return `${option.name}`;
			}}
			options={options}
			autoComplete
			includeInputInList
			autoHighlight
			filterSelectedOptions
			value={tags}
			onChange={(e, nv) => {
				onChange(nv.map(t => t._id));
			}}
			onInputChange={onInputChange}
			renderInput={(params) => (
				<TextField
					{...params}
					name={label.toLowerCase()}
					label={label}
					fullWidth
				/>
			)}
			renderTags={(value, getTagProps) =>
				tags.map((option, index) => {
					return (
						<TagItem
							tag={option}
							{...getTagProps({ index })}
						/>
					);
				})
			}
			renderOption={(props, option) => {
				return (
					<TagItem
						{...props}
						key={option._id}
						tag={option}
						className={null}
					/>
				);
			}}
		/>
	);
};
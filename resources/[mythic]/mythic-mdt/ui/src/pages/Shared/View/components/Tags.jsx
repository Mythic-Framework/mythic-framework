import React from 'react';
import { useSelector } from 'react-redux';
import { List, ListItem, ListItemText } from '@mui/material';
import TagItem from '../../Create/components/TagItem';

export default ({ tags }) => {
	const availableTags = useSelector(state => state.data.data.tags);
	const tagList = tags.map(t => availableTags.find(tData => tData._id == t));

	if (tagList && tagList.length > 0) {
		return (
			<>
				<ListItem>
					<ListItemText primary="Tags" />
				</ListItem>	
				{tagList.map((item, k) => {
					return (
						<TagItem
							key={`tag-${k}`}
							tag={item}
							ignorePermissions
						/>
					);
				})}
			</>
		);
	} else return null;
};

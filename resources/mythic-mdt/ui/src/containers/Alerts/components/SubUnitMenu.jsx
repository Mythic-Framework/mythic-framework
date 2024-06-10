import React, { useState } from 'react';
import { Menu, MenuItem } from '@mui/material';
import { makeStyles } from '@mui/styles';
//import NestedMenuItem from 'material-ui-nested-menu-item';

const useStyles = makeStyles((theme) => ({}));

export default ({ unit, onChange }) => {
	const classes = useStyles();

	const [anchorEl, setAnchorEl] = useState(null);
	const [open, setOpen] = useState(null);

	return (
		<>
			<MenuItem onClick={(e) => {
				setAnchorEl(e.currentTarget);
				setOpen(true);
			}}>
				Remove Unit
			</MenuItem>
			<Menu 
				anchorEl={anchorEl} 
				open={open != null} 
				onClose={() => setOpen(null)}
				PaperProps={{
					style: {
						maxHeight: 100,
						width: '20ch',
					},
				}}
			>
				{Boolean(open) && (
					<div>
						{unit.units.map((u) => {
							return (
								<MenuItem key={u} onClick={() => onChange(u)}>
									{u}
								</MenuItem>
							);
						})}
					</div>
				)}
			</Menu>
		</>

	);
};
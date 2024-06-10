import React, { useEffect, useState } from 'react';
import {
	Divider,
	Button,
	Grid,
	IconButton,
	TextField,
	InputAdornment,
	MenuItem,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useDispatch, useSelector } from 'react-redux';
import Truncate from '@nosferatu500/react-truncate';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { CSSTransition, TransitionGroup } from 'react-transition-group';
import { toast } from 'react-toastify';

import TagItem from '../Shared/Create/components/TagItem';
import { Modal } from '../../components';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 20,
		height: '100%',
	},
	tagsWrapper: {
		height: '90%',
		display: 'flex',
		flexDirection: 'row',
		flexWrap: 'wrap',
		placeContent: 'flex-start',
		//gap: 5,
		overflowY: 'auto',
		overflowX: 'hidden',
		//justifyContent: 'space-between',
	},
	field: {
		marginBottom: 15,
	},
	key: {
		fontSize: 16,
		color: theme.palette.text.alt,
		display: 'inline-flex',
		marginLeft: 10,
		height: 'fit-content',
	},
	keyTitle: {
		fontSize: 26,
		color: theme.palette.text.main,
		marginRight: 16,
	},
}));

const initialState = {
	name: '',
    requiredPermission: false,
    restrictViewing: false,
    style: {
        color: '',
        backgroundColor: '#1eadd9',
    }
};

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();
    const availableTags = useSelector(state => state.data.data.tags);
    const availablePermissions = useSelector(state => state.data.data.permissions);

	const allJobData = useSelector(state => state.data.data.governmentJobsData);

	const [search, setSearch] = useState('');
	const [selected, setSelected] = useState(null);
	const [filtered, setFiltered] = useState(Array());

	useEffect(() => {
        let rgx = new RegExp(search, 'i');
		setFiltered(availableTags.filter(t => t.name.match(rgx)));
	}, [search]);

	useEffect(() => {
		let rgx = new RegExp(search, 'i');
		setFiltered(availableTags.filter(t => t.name.match(rgx)));
	}, [availableTags]);

	const onSubmit = async (e) => {
		e.preventDefault();

		try {
			let res = await (
				await Nui.send(selected._id ? 'Update' : 'Create', {
					type: 'tag',
					doc: selected,
				})
			).json();

			if (res) {
				toast.success(`Tag ${selected._id ? 'Edited' : 'Created'}`);
				setSelected(null);
			} else
				toast.error(
					`Unable to ${selected._id ? 'Edit' : 'Create'} Tag`,
				);
		} catch (err) {
			console.log(err);
			toast.error(`Unable to ${selected._id ? 'Edit' : 'Create'} Tag`);
		}
	};

	const onChange = (e) => {
		setSelected({
			...selected,
			[e.target.name]: e.target.value,
		});
	};

	const onDelete = async () => {
		try {
			let res = await (
				await Nui.send('Delete', {
					type: 'tag',
					id: selected._id,
				})
			).json();

			if (res) {
				toast.success(`Tag Deleted`);
				setSelected(null);
			} else toast.error('Unable to Delete Tag');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Delete Tag');
		}
	};

	return (
		<div className={classes.wrapper}>
			<Grid container spacing={2} className={classes.field}>
				<Grid item xs={6}>
					<div className={classes.key}>
						<div className={classes.keyTitle}>
							Edit Report Tags
						</div>
					</div>
				</Grid>
				<Grid item xs={4}>
					<TextField
						fullWidth
						variant="outlined"
						name="search"
						value={search}
						onChange={(e) => setSearch(e.target.value)}
						label="Search Tags"
						InputProps={{
							endAdornment: (
								<InputAdornment position="end">
									{search != '' && (
										<IconButton
											type="button"
											onClick={() => setSearch('')}
										>
											<FontAwesomeIcon
												icon={['fas', 'xmark']}
											/>
										</IconButton>
									)}
								</InputAdornment>
							),
						}}
					/>
				</Grid>
				<Grid item xs={2}>
					<Button
						fullWidth
						variant="outlined"
						style={{ height: '100%' }}
						onClick={() => setSelected(initialState)}
					>
						Create Tag
					</Button>
				</Grid>
			</Grid>
			<TransitionGroup className={classes.tagsWrapper}>
				{filtered
					.map((tag) => {
						return (
							<CSSTransition
								key={`avail-${tag._id}`}
								timeout={500}
								classNames="item"
							>
                                <TagItem
                                    tag={tag}
                                    onClick={() => setSelected({
                                        ...tag,
                                        requiredPermission: tag.requiredPermission ?? false,
                                        restrictViewing: tag.restrictViewing ?? false,
                                    })}
                                />
							</CSSTransition>
						);
					})}
			</TransitionGroup>
			<Modal
				open={selected != null}
				title={
                    <>
                        {`${selected?._id ? 'Edit' : 'Create'} Tag`}
                        <TagItem tag={selected} />
                    </>
                }
				submitLang={selected?._id ? 'Edit' : 'Create'}
				deleteLang="Delete"
				onSubmit={onSubmit}
				onClose={() => setSelected(null)}
				onDelete={selected?._id ? onDelete : null}
			>
				{Boolean(selected) ? (
					<>
						<TextField
							fullWidth
							required
							className={classes.field}
							label="Name"
							name="name"
							value={selected.name}
							onChange={onChange}
                            inputProps={{
                                maxLength: 69,
                            }}
						/>

						<TextField
							select
							fullWidth
							label="Required Permission to Use Tag"
							name="requiredPermission"
							className={classes.field}
							value={selected.requiredPermission}
							onChange={onChange}
                            onChange={(e) => {
                                if (!e.target.value) {
                                    setSelected({
                                        ...selected,
                                        requiredPermission: false,
                                        restrictViewing: false,
                                    });
                                } else onChange(e);
                            }}
						>
                            <MenuItem value={false}>None</MenuItem>
                            {Object.keys(availablePermissions).sort().map(perm => (
                                <MenuItem
                                    key={perm}
                                    value={perm}
                                >
									{availablePermissions[perm]?.name}{(availablePermissions[perm]?.restrict?.job) ? ` - ${allJobData?.[availablePermissions[perm]?.restrict?.job]?.Name}` : ''}
                                </MenuItem>
                            ))}
						</TextField>
                        <TextField
							select
							fullWidth
							label="Restrict Viewing of Reports with Tag"
							name="restrictViewing"
							className={classes.field}
							value={selected.restrictViewing}
                            disabled={!selected.requiredPermission}
							onChange={onChange}
						>
                            <MenuItem value={false}>No Restriction</MenuItem>
                            <MenuItem value={true}>Require the Permission Above to View</MenuItem>
						</TextField>
						{selected.style && <Grid container spacing={2}>
							<Grid item xs={6}>
								<TextField
									fullWidth
									className={classes.field}
									label="Background Color"
									value={selected.style.backgroundColor}
									onChange={(e) => {
                                        setSelected({
                                            ...selected,
                                            style: {
                                                ...selected.style,
                                                backgroundColor: e.target.value,
                                            }
                                        });
                                    }}
								/>
							</Grid>
							<Grid item xs={6}>
								<TextField
									fullWidth
									className={classes.field}
									label="Text Color"
									value={selected.style.color}
                                    onChange={(e) => {
                                        setSelected({
                                            ...selected,
                                            style: {
                                                ...selected.style,
                                                color: e.target.value,
                                            }
                                        });
                                    }}
								/>
							</Grid>
						</Grid>}
					</>
				) : null}
			</Modal>
		</div>
	);
};
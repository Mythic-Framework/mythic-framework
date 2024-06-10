import React, { useEffect, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import {
    Grid,
	TextField,
	InputAdornment,
	IconButton,
	Pagination,
	List,
    MenuItem,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../util/Nui';
import { Loader } from '../../components';

import Player from './Player';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '100%',
	},
	search: {
		height: '10%',
	},
	results: {
		height: '90%',
	},
	items: {
		maxHeight: '95%',
		height: '95%',
		overflowY: 'auto',
		overflowX: 'hidden',
	},
    loader: {
        marginTop: '10%',
    }
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const PER_PAGE = 32;

	const [searched, setSearched] = useState('');
	const [pages, setPages] = useState(1);
	const [page, setPage] = useState(1);
	const [loading, setLoading] = useState(false);

	const [results, setResults] = useState(Array());
    const [players, setPlayers] = useState(Array());

	useEffect(() => {
        fetch();
		let interval = setInterval(() => fetch(), 60 * 1000);

        return () => {
            clearInterval(interval);
        }
	}, []);

	useEffect(() => {
		setPages(Math.ceil(players.length / PER_PAGE));
	}, [players]);

    useEffect(() => {
        setPlayers(results.filter((r) => {
            return (
                (r.Name.toLowerCase().includes(searched.toLowerCase())) ||
                (r.AccountID == parseInt(searched)) ||
                (r.Character && `${r.Character?.First} ${r.Character?.Last}`.toLowerCase().includes(searched.toLowerCase())) ||
                (r.Character && (r.Character.SID == parseInt(searched)))
            )
        }));
    }, [results, searched]);

    const fetch = async () => {
        setLoading(true);

        try {
            let res = await(await Nui.send('GetPlayerList', {
                disconnected: true
            })).json()
            if (res) setResults(res);
        } catch(e) {
            // setResults([
            //     {
            //         AccountID: 1,
            //         Source: 1,
            //         Name: 'Dr Nick',
            //         Character: {
            //             First: 'Walter',
            //             Last: 'Western',
            //             SID: 3
            //         },
            //         Disconnected: true,
			// 		DisconnectedTime: 1641993114,
			// 		Reconnected: 6,
            //     },
            //     {
            //         AccountID: 2,
            //         Source: 2,
            //         Name: 'Panda',
            //         // Character: {
            //         //     First: 'Willy',
            //         //     Last: 'Western',
            //         //     SID: 4
            //         // }
            //         Disconnected: true,
			// 		DisconnectedTime: 1641995507,
			// 		Reconnected: 3,
            //     },
            // ])
            //console.log(e)
        }

        setLoading(false);
    }

	const onClear = () => {
        setSearched('');
	};

	const onPagi = (e, p) => {
		setPage(p);
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.search}>
                <Grid container spacing={1}>
                    <Grid item xs={12}>
                        <TextField
                            fullWidth
                            variant="outlined"
                            name="search"
                            value={searched}
                            onChange={(e) => setSearched(e.target.value)}
                            label="Search"
                            InputProps={{
                                endAdornment: (
                                    <InputAdornment position="end">
                                        {searched != '' && (
                                            <IconButton
                                                type="button"
                                                onClick={onClear}
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
                </Grid>
			</div>
			<div className={classes.results}>
				{loading ? (
                    <Loader text="Loading" />
				) : (
					<>
						<List className={classes.items}>
							{players
                                .sort((a, b) => b.DisconnectedTime - a.DisconnectedTime)
								.slice((page - 1) * PER_PAGE, page * PER_PAGE)
								.map((p) => {
									return (
										<Player
											key={p.Source}
											player={p}
										/>
									);
								})}
						</List>
						{pages > 1 && (
							<Pagination
								variant="outlined"
								shape="rounded"
								color="primary"
								page={page}
								count={pages}
								onChange={onPagi}
							/>
						)}
					</>
				)}
			</div>
		</div>
	);
};

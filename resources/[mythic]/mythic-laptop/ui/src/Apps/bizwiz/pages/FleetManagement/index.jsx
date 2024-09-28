import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import {
  TextField,
  InputAdornment,
  IconButton,
  List,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../../../util/Nui';
import { Loader } from '../../../../components';
import Item from './Vehicle';

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
  empty: {
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    width: '100%',
    height: '60%',
    textAlign: 'center',
  }
}));

export default () => {
  const classes = useStyles();
  const onDuty = useSelector((state) => state.data.data.onDuty);

  const [searched, setSearched] = useState('');
  const [loading, setLoading] = useState(false);
  const [err, setErr] = useState(false);

  const [results, setResults] = useState(Array());
  const [filtered, setFiltered] = useState(Array());

  useEffect(() => {
    fetch();
  }, []);

  const fetch = async () => {
    setLoading(true);

    try {
      let res = await (
        await Nui.send('ViewVehicleFleet', {})
      ).json();
      if (res) setResults(res);
      else setErr(true);
      setLoading(false);
    } catch (err) {
      console.log(err);
      setErr(true);
      setLoading(false);
    }
  }

  useEffect(() => {
    setFiltered(results.filter(r => {
      return (
        (r.VIN.toLowerCase().includes(searched.toLowerCase())) ||
        (r.RegisteredPlate.toLowerCase().includes(searched.toLowerCase())) ||
        (`${r.Make} ${r.Model}`.toLowerCase().includes(searched.toLowerCase()))
      );
    }));
  }, [results, searched]);

  const onSearch = (e) => {
    e.preventDefault();


  };

  const onClear = () => {
    setSearched('');
  };

  return (
    <div className={classes.wrapper}>
      <div className={classes.search}>
        <form onSubmit={onSearch}>
          <TextField
            fullWidth
            variant="outlined"
            name="search"
            value={searched}
            onChange={e => setSearched(e.target.value)}
            error={err}
            helperText={err ? 'Error Performing Search' : null}
            label="Search By Plate, VIN or Make/Model"
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
        </form>
      </div>
      <div className={classes.results}>
        {loading ? (
          <Loader text="Loading" />
        ) : (
          <>
            <List className={classes.items}>
              {results.length == 0 && <div className={classes.empty}><h2>This Business Has No Fleet Vehicles</h2></div>}
              {filtered
                .sort((a, b) => a.RegistrationDate - b.RegistrationDate)
                .map((result) => {
                  return (
                    <Item
                      key={result.VIN}
                      vehicle={result}
                    />
                  );
                })}
            </List>
          </>
        )}
      </div>
    </div>
  );
};

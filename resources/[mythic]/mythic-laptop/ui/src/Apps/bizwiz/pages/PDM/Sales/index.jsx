import React, { useEffect, useMemo, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import {
	Grid,
	TextField,
	InputAdornment,
	IconButton,
	Pagination,
	List,
	Button,
	MenuItem,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { throttle } from 'lodash';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { usePermissions, useAlert } from '../../../../../hooks';

import Nui from '../../../../../util/Nui';
import { Loader } from '../../../../../components';

import Item from './components/Vehicle';
import { vehicleCategories } from './data';
import SaleForm from './SaleForm';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '100%',
	},
	search: {
		//height: '10%',
	},
	results: {
		//height: '',
	},
	noResults: {
		margin: '15% 0',
		textAlign: 'center',
		fontSize: 22,
		color: theme.palette.text.main,
	},
	items: {
		maxHeight: '95%',
		height: '95%',
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	searchButton: {
		height: '90%',
		// marginBottom: 10,
	},
}));

const escapeRegex = (string) => {
    return string.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
}

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();
    const alert = useAlert();
	const PER_PAGE = 6;

	const searchTerm = useSelector((state) => state.data.data.pdmSearch) || '';

	const [pages, setPages] = useState(1);
	const [page, setPage] = useState(1);
	const [loading, setLoading] = useState(false);
	const [err, setErr] = useState(false);
	const [results, setResults] = useState(Array());
    const [filtered, setFiltered] = useState(Array());
    const [cat, setCat] = useState('all');

    const [sellingOpen, setSellingOpen] = useState(false);
    const [selling, setSelling] = useState(null);

    useEffect(() => {
        if (results?.stock) {
            const escapedSearchTerm = escapeRegex(searchTerm ?? '');
            setFiltered(results?.stock
                .filter(s => cat == 'all' || cat == s?.data?.category)
                .filter(s => new RegExp(escapedSearchTerm, 'i').test(`${s.data.make} ${s.data.model}`))
            );

            setPage(1);
        } else {
            setFiltered(Array())
        };
    }, [results, cat, searchTerm]);

	useEffect(() => {
		setPages(Math.ceil(filtered?.length / PER_PAGE));
	}, [filtered]);

    const fetch = useMemo(() => throttle(async (value) => {
		setLoading(true);
        setPage(1);

        try {
            let res = await (
                await Nui.send('PDMGetStock', {})
            ).json();

            if (res) {
                setResults(res);
            } else throw res;
            setLoading(false);
        } catch (err) {
            console.log(err);
            setErr(true);

            // setResults({
            //     stock: [
            //         {
            //             "lastStocked": 1649102142,
            //             "_id": "624b4d3e977787166ceb5997",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "motorcycles",
            //                 "model": "Faggio",
            //                 "price": 16000,
            //                 "make": "Pegassi",
            //                 "class": "M"
            //             },
            //             "quantity": 10,
            //             "default": true,
            //             "vehicle": "faggio"
            //         },
            //         {
            //             "lastStocked": 1641146220,
            //             "_id": "61d1e76c702516077433ebd2",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "suv",
            //                 "model": "Seminole",
            //                 "price": 23750,
            //                 "make": "Canis",
            //                 "class": "C"
            //             },
            //             "quantity": 10,
            //             "default": true,
            //             "vehicle": "seminole"
            //         },
            //         {
            //             "_id": "61d31a5e57c1b4dff661d134",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "compact",
            //                 "model": "Benefactor",
            //                 "price": 21000,
            //                 "make": "Panto",
            //                 "class": "C"
            //             },
            //             "quantity": 5,
            //             "vehicle": "panto",
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "vehicle": "rhapsody",
            //             "_id": "61d31b3f57c1b4dff661d135",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "compact",
            //                 "model": "Declasse",
            //                 "price": 19000,
            //                 "make": "Rhapsody",
            //                 "class": "C"
            //             },
            //             "quantity": 9,
            //             "lastPurchase": 1644787145,
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "_id": "61d31c3757c1b4dff661d136",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "suv",
            //                 "model": "Bravado",
            //                 "price": 37500,
            //                 "make": "Gresley",
            //                 "class": "B"
            //             },
            //             "quantity": 14,
            //             "vehicle": "gresley",
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "_id": "61d31d5457c1b4dff661d137",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "muscle",
            //                 "model": "Willard",
            //                 "price": 55700,
            //                 "make": "Faction",
            //                 "class": "B"
            //             },
            //             "quantity": 3,
            //             "vehicle": "faction",
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "vehicle": "moonbeam",
            //             "_id": "61d31e0957c1b4dff661d138",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "van",
            //                 "model": "Declasse",
            //                 "price": 55700,
            //                 "make": "Moonbeam",
            //                 "class": "C"
            //             },
            //             "quantity": 5,
            //             "lastPurchase": 1642338096,
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "vehicle": "dilettante",
            //             "_id": "61d31ec357c1b4dff661d139",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "compact",
            //                 "model": "Karin",
            //                 "price": 19500,
            //                 "make": "Dilettante",
            //                 "class": "D"
            //             },
            //             "quantity": 7,
            //             "lastPurchase": 1650132367,
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "vehicle": "speedo",
            //             "_id": "61d31f5057c1b4dff661d13a",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "van",
            //                 "model": "Vapid",
            //                 "price": 38500,
            //                 "make": "Speedo",
            //                 "class": "D"
            //             },
            //             "quantity": 1,
            //             "lastPurchase": 1649695079,
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "_id": "61d31fef57c1b4dff661d13b",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "suv",
            //                 "model": "Lampadati",
            //                 "price": 77750,
            //                 "make": "Novak",
            //                 "class": "B"
            //             },
            //             "quantity": 2,
            //             "vehicle": "novak",
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "_id": "61d3208257c1b4dff661d13c",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "sedans",
            //                 "model": "Albany",
            //                 "price": 37750,
            //                 "make": "Washington",
            //                 "class": "B"
            //             },
            //             "quantity": 4,
            //             "vehicle": "washington",
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "_id": "61d3211357c1b4dff661d13d",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "sedans",
            //                 "model": "Vulcar",
            //                 "price": 34500,
            //                 "make": "Warrener",
            //                 "class": "C"
            //             },
            //             "quantity": 2,
            //             "vehicle": "warrener",
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "_id": "61d321ba57c1b4dff661d13e",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "sedans",
            //                 "model": "Dundreary",
            //                 "price": 12650,
            //                 "make": "Regina",
            //                 "class": "D"
            //             },
            //             "quantity": 10,
            //             "vehicle": "regina",
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "_id": "61d3222957c1b4dff661d13f",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "sedans",
            //                 "model": "Declasse",
            //                 "price": 29150,
            //                 "make": "Tornado",
            //                 "class": "D"
            //             },
            //             "quantity": 3,
            //             "vehicle": "tornado",
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "_id": "61d322c657c1b4dff661d140",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "suv",
            //                 "model": "Fathom",
            //                 "price": 43000,
            //                 "make": "FQ-2",
            //                 "class": "C"
            //             },
            //             "quantity": 6,
            //             "vehicle": "fq2",
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "_id": "61d3234557c1b4dff661d141",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "compact",
            //                 "model": "Weeny",
            //                 "price": 29600,
            //                 "make": "Issi",
            //                 "class": "C"
            //             },
            //             "quantity": 6,
            //             "vehicle": "issi2",
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "_id": "61d323db57c1b4dff661d142",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "suv",
            //                 "model": "Vapid",
            //                 "price": 27500,
            //                 "make": "Radius",
            //                 "class": "C"
            //             },
            //             "quantity": 7,
            //             "vehicle": "radi",
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "vehicle": "buffalo2",
            //             "_id": "61d326ca57c1b4dff661d144",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "sedans",
            //                 "model": "Bravado",
            //                 "price": 57000,
            //                 "make": "Buffalo S",
            //                 "class": "B"
            //             },
            //             "quantity": 5,
            //             "lastPurchase": 1641501144,
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "_id": "61d3272857c1b4dff661d145",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "sedans",
            //                 "model": "Ubermacht",
            //                 "price": 50000,
            //                 "make": "Schafter",
            //                 "class": "B"
            //             },
            //             "quantity": 2,
            //             "vehicle": "schafter2",
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "_id": "61d3278457c1b4dff661d146",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "sedans",
            //                 "model": "Declasse",
            //                 "price": 24000,
            //                 "make": "Premier",
            //                 "class": "B"
            //             },
            //             "quantity": 6,
            //             "vehicle": "premier",
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "_id": "61d327d057c1b4dff661d147",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "sedans",
            //                 "model": "Cheval",
            //                 "price": 30000,
            //                 "make": "Surge",
            //                 "class": "B"
            //             },
            //             "quantity": 6,
            //             "vehicle": "surge",
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "_id": "61d3287357c1b4dff661d148",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "sport",
            //                 "model": "Pfister",
            //                 "price": 93000,
            //                 "make": "Comet",
            //                 "class": "B"
            //             },
            //             "quantity": 2,
            //             "vehicle": "comet2",
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "_id": "61d3290057c1b4dff661d149",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "sedans",
            //                 "model": "Ubermacht",
            //                 "price": 32000,
            //                 "make": "Oracle XS",
            //                 "class": "B"
            //             },
            //             "quantity": 2,
            //             "vehicle": "oracle2",
            //             "lastStocked": 1641146220
            //         },
            //         {
            //             "_id": "61da43c15ab9b10ffc96a440",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "compact",
            //                 "model": "Asbo",
            //                 "price": 26000,
            //                 "make": "Maxwell",
            //                 "class": "C"
            //             },
            //             "quantity": 5,
            //             "vehicle": "asbo",
            //             "lastStocked": 1641694145
            //         },
            //         {
            //             "vehicle": "sugoi",
            //             "_id": "61da44ee5ab9b10ffc96a449",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "sedans",
            //                 "model": "Sugoi",
            //                 "price": 55500,
            //                 "make": "Dinka",
            //                 "class": "B"
            //             },
            //             "quantity": 1,
            //             "lastPurchase": 1645480773,
            //             "lastStocked": 1641694446
            //         },
            //         {
            //             "_id": "61da45785ab9b10ffc96a451",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "super",
            //                 "model": "Seven-70",
            //                 "price": 170000,
            //                 "make": "Dewbauchee",
            //                 "class": "A"
            //             },
            //             "quantity": 1,
            //             "vehicle": "seven70",
            //             "lastStocked": 1641694584
            //         },
            //         {
            //             "vehicle": "DRAFTGPR",
            //             "_id": "61dc789772b09b02282a943c",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "sport",
            //                 "model": "DrafterWB",
            //                 "price": 195000,
            //                 "make": "Obey",
            //                 "class": "S"
            //             },
            //             "quantity": 0,
            //             "lastPurchase": 1645307235,
            //             "lastStocked": 1641838743
            //         },
            //         {
            //             "_id": "61dc790272b09b02282a9440",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "sport",
            //                 "model": "Drafter",
            //                 "price": 125000,
            //                 "make": "Obey",
            //                 "class": "A"
            //             },
            //             "quantity": 5,
            //             "lastStocked": 1641838850,
            //             "vehicle": "drafter"
            //         },
            //         {
            //             "_id": "61dc79fe72b09b02282a9446",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "sport",
            //                 "model": "SentinelSG4",
            //                 "price": 138000,
            //                 "make": "Ubermacht",
            //                 "class": "A"
            //             },
            //             "quantity": 4,
            //             "lastStocked": 1641839102,
            //             "vehicle": "sentinelsg4"
            //         },
            //         {
            //             "vehicle": "kanjo",
            //             "_id": "61dc7a3d72b09b02282a944a",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "compact",
            //                 "model": "Kanjo",
            //                 "price": 62000,
            //                 "make": "Dinka",
            //                 "class": "A"
            //             },
            //             "quantity": 6,
            //             "lastPurchase": 1642622468,
            //             "lastStocked": 1641839165
            //         },
            //         {
            //             "_id": "61dc7a9872b09b02282a944d",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "muscle",
            //                 "model": "Dominator",
            //                 "price": 75000,
            //                 "make": "Vapid",
            //                 "class": "A"
            //             },
            //             "quantity": 3,
            //             "lastStocked": 1641839256,
            //             "vehicle": "dominator"
            //         },
            //         {
            //             "vehicle": "Rebla",
            //             "_id": "61dc7be972b09b02282a9452",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "suv",
            //                 "model": "Rebla",
            //                 "price": 88000,
            //                 "make": "Ubermacht",
            //                 "class": "B"
            //             },
            //             "quantity": 3,
            //             "lastPurchase": 1642092808,
            //             "lastStocked": 1641839593
            //         },
            //         {
            //             "vehicle": "taxi",
            //             "_id": "61dc7c3972b09b02282a9454",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "utility",
            //                 "model": "Taxi",
            //                 "price": 15000,
            //                 "make": "Vapid",
            //                 "class": "C"
            //             },
            //             "quantity": 2,
            //             "lastPurchase": 1643838387,
            //             "lastStocked": 1641839673
            //         },
            //         {
            //             "lastStocked": 1642512323,
            //             "_id": "61e6bfc3ca576005782793c0",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "utility",
            //                 "model": "Mule 4",
            //                 "price": 132000,
            //                 "make": "Maibatsu",
            //                 "class": "u"
            //             },
            //             "quantity": 8,
            //             "lastPurchase": 1643820844,
            //             "vehicle": "mule4"
            //         },
            //         {
            //             "vehicle": "benson",
            //             "_id": "6206d1ebf224c43028363c79",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "utility",
            //                 "model": "Benson",
            //                 "price": 150000,
            //                 "make": "Vapid",
            //                 "class": "U"
            //             },
            //             "quantity": 8,
            //             "lastPurchase": 1644755909,
            //             "lastStocked": 1644614123
            //         },
            //         {
            //             "_id": "624f387313ff43067cfe449a",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "import",
            //                 "model": "John Cooper Works",
            //                 "price": 90000,
            //                 "make": "Mini",
            //                 "class": "A"
            //             },
            //             "quantity": 1,
            //             "vehicle": "mcjcw20",
            //             "lastStocked": 1649358963
            //         },
            //         {
            //             "_id": "624f39b413ff43067cfe44a6",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "sedans",
            //                 "model": "Tailgater S",
            //                 "price": 82500,
            //                 "make": "Obey",
            //                 "class": "A"
            //             },
            //             "quantity": 1,
            //             "vehicle": "tailgater2",
            //             "lastStocked": 1649359284
            //         },
            //         {
            //             "_id": "6251a4c3d537b20804d39b00",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "motorcycles",
            //                 "model": "Daemon - Lost Edition",
            //                 "price": 70000,
            //                 "make": "WMC",
            //                 "class": "M"
            //             },
            //             "quantity": 3,
            //             "lastStocked": 1649517763,
            //             "vehicle": "DAEMON"
            //         },
            //         {
            //             "_id": "6251a5cad537b20804d39b0e",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "motorcycles",
            //                 "model": "Daemon",
            //                 "price": 70000,
            //                 "make": "WMC",
            //                 "class": "M"
            //             },
            //             "quantity": 5,
            //             "lastStocked": 1649518026,
            //             "vehicle": "DAEMON2"
            //         },
            //         {
            //             "_id": "6251a64bd537b20804d39b20",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "motorcycles",
            //                 "model": "Bati 801",
            //                 "price": 62000,
            //                 "make": "Pegassi",
            //                 "class": "M"
            //             },
            //             "quantity": 10,
            //             "lastStocked": 1649518155,
            //             "vehicle": "BATI"
            //         },
            //         {
            //             "_id": "62575857c918c704201c3e83",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "sedans",
            //                 "model": "Sultan",
            //                 "price": 100000,
            //                 "make": "Karen",
            //                 "class": "B"
            //             },
            //             "quantity": 1,
            //             "vehicle": "sultan",
            //             "lastStocked": 1649891415
            //         },
            //         {
            //             "_id": "6258b8f66840c90f8088627f",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "compact",
            //                 "model": "Dynasty",
            //                 "price": 29600,
            //                 "make": "Weeny",
            //                 "class": "D"
            //             },
            //             "quantity": 1,
            //             "vehicle": "dynasty",
            //             "lastStocked": 1649981686
            //         },
            //         {
            //             "_id": "6258b93a6840c90f8088628b",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "offroad",
            //                 "model": "Kamacho",
            //                 "price": 42550,
            //                 "make": "Canis",
            //                 "class": "C"
            //             },
            //             "quantity": 2,
            //             "vehicle": "kamacho",
            //             "lastStocked": 1649981754
            //         },
            //         {
            //             "_id": "6258ba1f6840c90f808862be",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "sedans",
            //                 "model": "Komoda",
            //                 "price": 105000,
            //                 "make": "Lampadati",
            //                 "class": "B"
            //             },
            //             "quantity": 3,
            //             "vehicle": "komoda",
            //             "lastStocked": 1649981983
            //         },
            //         {
            //             "lastStocked": 1650056420,
            //             "_id": "6259dce4410a7517c018dd70",
            //             "dealership": "pdm",
            //             "data": {
            //                 "category": "muscle",
            //                 "model": "Sabre Turbo",
            //                 "price": 110000,
            //                 "make": "Declasse",
            //                 "class": "A"
            //             },
            //             "quantity": 1,
            //             "lastPurchase": 1650059591,
            //             "vehicle": "sabregt"
            //         }
            //     ],
            //     dealerData: {
            //         "profitPercentage": 15,
            //         "commission": 25
            //     }
            // });

            setLoading(false);
        }
	}, 3000), []);

	useEffect(() => {
		fetch();
	}, []);

	const onSearch = (e) => {
		e.preventDefault();
	};

	const onSearchChange = (e) => {
        dispatch({
            type: 'SET_DATA',
            payload: {
                type: 'pdmSearch',
                data: e.target.value,
            },
        });
	};

	const onClear = () => {
        dispatch({
            type: 'SET_DATA',
            payload: {
                type: 'pdmSearch',
                data: null,
            },
        });
		setResults(Array());
	};

	const onPagi = (e, p) => {
		setPage(p);
	};

	const onRefresh = () => {
		fetch();
	};

    const sellVehicle = (vehicle) => {
        setSelling(vehicle);
    };

    const completeSale = async (data) => {
        setSellingOpen(false);
        setLoading(true);

        // console.log({
        //     ...data,
        //     vehicle: selling.vehicle,
        // });

        try {
            let res = await (
                await Nui.send('PDMStartSale', {
                    ...data,
                    vehicle: selling.vehicle,
                })
            ).json();

            if (res && res.success) {
                alert(res?.message ?? 'Success');
                setSelling(null);

                fetch();
            } else {
                alert(res?.message ?? 'Error Initiating Sale');
            };
            setLoading(false);
            setSellingOpen(false);
        } catch (err) {
            console.log(err);
            alert('Error Initiating Sale');

            setLoading(false);
            setSellingOpen(false);
        }
    };

	return (
		<div className={classes.wrapper}>
			<div className={classes.search}>
				<form onSubmitCapture={onSearch}>
					<Grid container spacing={1}>
                        <Grid item xs={3}>
                            <TextField
                                select
                                fullWidth
                                label="Category"
                                name="type"
                                className={classes.editorField}
                                value={cat}
                                onChange={(e) => setCat(e.target.value)}
                            >
                                {vehicleCategories.map(option => (
                                    <MenuItem key={option.value} value={option.value}>
                                        {option.label}
                                    </MenuItem>
                                ))}
                            </TextField>
                        </Grid>
						<Grid item xs={7}>
							<TextField
								fullWidth
								variant="outlined"
								name="search"
								value={searchTerm}
								onChange={onSearchChange}
								error={err}
								helperText={err ? 'Error Performing Search' : null}
								label="Search"
								InputProps={{
									endAdornment: (
										<InputAdornment position="end">
											{searchTerm != '' && (
												<IconButton
													type="button"
													onClick={onClear}
												>
													<FontAwesomeIcon
														icon={['fas', 'xmark']}
													/>
												</IconButton>
											)}
											<IconButton
												type="submit"
												disabled={loading}
											>
												<FontAwesomeIcon
													icon={['fas', 'magnifying-glass']}
												/>
											</IconButton>
										</InputAdornment>
									),
								}}
							/>
						</Grid>
						<Grid item xs={2}>
							<Button
								variant="outlined"
								fullWidth
								style={{ height: '100%' }}
								onClick={onRefresh}
							>
								Refresh
							</Button>
						</Grid>
					</Grid>
				</form>
			</div>
			<div className={classes.results}>
				{loading ? (
					<Loader text="Loading" />
				) : results?.stock?.length > 0 ? (
					<>
						<List className={classes.items}>
							{filtered
                                .sort((a, b) => a.data?.price - b.data?.price)
								.slice((page - 1) * PER_PAGE, page * PER_PAGE)
								.map((result) => {
									return (
										<Item
											key={result._id}
											vehicle={result}
                                            dealerData={results.dealerData}
                                            onClick={() => {
                                                setSellingOpen(true);
                                                sellVehicle(result);
                                            }}
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
				) : <p className={classes.noResults}>No Results Found</p>}
			</div>
            <SaleForm 
                open={sellingOpen} 
                vehicle={selling} 
                onClose={() => setSellingOpen(false)}
                onSubmit={completeSale}
                dealerData={results.dealerData}
                interest={results.interest}
            />
		</div>
	);
};

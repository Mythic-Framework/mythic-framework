import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';

import DOJ from '../../assets/img/seals/doj_seal.webp';
import LSPDBadge from '../../assets/img/seals/lspd_badge.webp';
import StateBadge from '../../assets/img/seals/sasp_seal.webp';
import RangerBadge from '../../assets/img/seals/sasp_seal.webp';
import MedicalServices from '../../assets/img/seals/medical_badge.webp';
import MedicalServices2 from '../../assets/img/seals/clsmd_badge.webp';
import MedicalServices3 from '../../assets/img/seals/MountZonah.webp';
import SheriffBadgeLS from '../../assets/img/seals/lssd_seal.webp';
import SheriffBadgeBC from '../../assets/img/seals/bcso_seal.webp';

import FibBadge from '../../assets/img/seals/fib_badge.webp';

const useStyles = makeStyles((theme) => ({
    container: {
        width: '100%',
        height: '100%',
        padding: '10%',
    },
    image: {
        margin: 'auto',
        width: '100%',
        marginTop: 25,
        left: 0,
        right: 0,
    }
}));

export default ({ badge }) => {
	const classes = useStyles();

    const getBadge = (id) => {
        switch(id) {
            case 'lspd':
                return LSPDBadge;
            case 'lscso':
                return SheriffBadgeLS;
            case 'bcso':
                return SheriffBadgeBC;
            case 'sasp':
                return StateBadge;
            case 'ranger':
                return RangerBadge;
            case 'fib':
                return FibBadge;
            case 'safd':
                return MedicalServices;
            case 'paleto':
                return MedicalServices;
            case 'pillbox':
                return MedicalServices;
            case 'sandy':
                return MedicalServices;
            case 'mrsa':
                return MedicalServices;
            case 'clsmd':
                return MedicalServices2;
            case 'fiacre':
                return MedicalServices;
            case 'zonah':
                return MedicalServices3;
            case 'groan':
                return MedicalServices;
            case 'prison':
                return MedicalServices;
            case 'doj':
            default:
                return DOJ;
        }
    };

	return (
		<div className={classes.container}>
            <img src={getBadge(badge)} className={classes.image} />
		</div>
	);
};

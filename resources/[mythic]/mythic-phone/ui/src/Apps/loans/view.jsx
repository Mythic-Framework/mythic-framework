import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import {
	Grid,
	AppBar,
    Tooltip,
    IconButton,
    TextField,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { useHistory } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Loader } from '../../components';
import Moment from 'react-moment';

import Nui from '../../util/Nui';
import { useAlert } from '../../hooks';
import { Modal } from '../../components';
import { getLoanTypeName, getLoanIdentifierType, getActualRemainingAmount, getNextPaymentAmount } from './utils';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
    header: {
		background: '#30518c',
	},
	titleBar: {
		padding: 15,
        fontSize: 20,
		lineHeight: '50px',
		height: 78,
	},
    subBar: {
		padding: 15,
		textAlign: 'left',
		lineHeight: '30px',
		backgroundColor: theme.palette.secondary.light,
	},
	accountBody: {
		padding: 20,
		overflowY: 'auto',
		overflowX: 'hidden',
		padding: 10,
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	accountBtn: {
		width: '90%',
		padding: 10,
		margin: '2.5% auto',
		position: 'relative',
		height: 75,
		background: theme.palette.secondary.dark,
		willChange: 'background',
		transition: 'background 400ms',
		borderRadius: 5,
		boxShadow: '0px 0px 12px -2px rgba(0,0,0,0.3)',
		'&:hover': {
			cursor: 'pointer',
		},
		'&:hover:not(.disabled)': {
			background: 'rgba(255, 255, 255, 0.01)',
		},
		'&.disabled': {
			opacity: '60%',
			color: theme.palette.secondary.contrastText,
		},
	},
	content: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		height: 'fit-content',
		width: '100%',
		padding: '5px 7.5% 5px 2%',
		textAlign: 'center',
		margin: 'auto',
		fontSize: 28,
		'& svg': {
			color: theme.palette.primary.main,
			fontSize: 35,
		},
	},
	currency: {
		color: theme.palette.success.main,
	},
	editField: {
		marginBottom: 20,
		width: '100%',
        '& p': {
            marginTop: 0,
        }
	},
}));

export default (props) => {
	const showAlert = useAlert();
    const history = useHistory();

	const classes = useStyles();
	const { loan } = props.match.params;
	const myLoans = useSelector(state => state.data.data.bankLoans.loans);

    const loanTypeIcons = {
        vehicle: 'car-side',
        property: 'house-building',
    }
	const loanData = myLoans && myLoans.find(l => l._id == loan);
    if (!loanData) return null;

	const [loading, setLoading] = useState(false);

    const [weeklyPayment, setWeeklyPayment] = useState(false);
    const [WPState, setWPState] = useState({});
    const onWPChange = (e) => {
        let val = e.target.value; 
        if (e.target.name === 'weeks' && WPState.allowAhead) {
            const remainingPayments = (loanData.TotalPayments - loanData.PaidPayments);
            if (val >= remainingPayments) {
                val = remainingPayments;
            } else if (val <= WPState.minWeeks) {
                val = WPState.minWeeks;
            }
        }
		setWPState({
			...WPState,
			[e.target.name]: val,
		});
	};

    const openWeeklyPayment = (ahead) => {
        if (ahead) {
            let minWeeks = 1;
            if (loanData.MissedPayments > 1) {
                const remainingPayments = (loanData.TotalPayments - loanData.PaidPayments);
                minWeeks = loanData.MissedPayments;
                if (minWeeks > remainingPayments) {
                    minWeeks = remainingPayments;
                }
            }
            setWPState({
                minWeeks,
                weeks: minWeeks,
                allowAhead: true,
            });
        } else {
            setWPState({
                minWeeks: 1,
                weeks: 1,
                allowAhead: false,
            });
        }
        setWeeklyPayment(true);
    };

    const makeWeeklyPayment = async (e) => {
        e.preventDefault();
        setWeeklyPayment(false);
        setLoading(true);

		try {
			let res = await (await Nui.send('Loans:Payment', {
                loan: loanData._id,
                weeks: WPState.weeks,
                paymentAhead: WPState.allowAhead,
			})).json();
			if (res && res.success) {
                if (res.paidOff) {
                    showAlert(`Loan Paid Off Completely!`);
                } else {
                    showAlert(`Loan Payment of $${res.paymentAmount} Successful`);
                }
                history.goBack();
			} else {
				showAlert(res.message ?? 'Loan Payment Failed');
			}
		} catch (err) {
			showAlert('Loan Payment Failed');
		}
        setLoading(false);
    };

    return (
        <>
            <div className={classes.wrapper}>
                <AppBar position="static" className={classes.header}>
                    <Grid container className={classes.titleBar}>
                        <Grid item xs={7} style={{ lineHeight: '50px' }}>
                            Loans - {getLoanTypeName(loanData.Type)}
                        </Grid>
                        <Grid item xs={5} style={{ textAlign: 'right' }}>
                            <Tooltip title={loanData._id}>
                                <span>
                                    <IconButton>
                                        <FontAwesomeIcon icon={['fas', loanTypeIcons[loanData.Type] ?? 'coin']} />
                                    </IconButton>
                                </span>
                            </Tooltip>
                        </Grid>
                    </Grid>
                    {(!loading && loanData) && <Grid container className={classes.subBar}>
                        <Grid item xs={12}>
                            {getLoanIdentifierType(loanData.Type)}: {loanData.AssetIdentifier}
                        </Grid>
                        <Grid item xs={6}>
                            Remaining:{' '}
                            <span className={classes.currency}>
                                ${getActualRemainingAmount(loanData).toLocaleString('en-US')}
                            </span>
                        </Grid>
                        <Grid item xs={6}>
                            Paid:{' '}
                            <span className={classes.currency}>
                                ${loanData.Paid.toLocaleString('en-US')}
                            </span>
                        </Grid>
                        <Grid item xs={6}>
                            Payments Paid: {loanData.PaidPayments}
                        </Grid>
                        <Grid item xs={6}>
                            Payments Remaining: {loanData.TotalPayments - loanData.PaidPayments}
                        </Grid>
                        <Grid item xs={6}>
                            Interest Rate: {loanData.InterestRate}%
                        </Grid>
                        {loanData.MissablePayments > 0 && <Grid item xs={6}>
                            Missed Payments: {loanData.MissedPayments}/{loanData.MissablePayments}
                        </Grid>}
                        <Grid item xs={12}><br /></Grid>
                        <Grid item xs={12}>
                            Last Payment:{' '}
                            {loanData.LastPayment ? 
                                <Moment unix date={loanData.LastPayment} calendar />
                                : 'No Payments Have Been Made'
                            }
                        </Grid>
                        <Grid item xs={12}>
                            Next Payment Due:{' '}
                            {loanData.NextPayment ? 
                                <Moment unix date={loanData.NextPayment} calendar />
                                : 'No More Payments are Due'
                            }
                        </Grid>
                        {(loanData.Remaining > 0 && loanData.NextPayment) && <Grid item xs={12}>
                            Next Payment Amount:{' '}
                            <span className={classes.currency}>
                                ${getNextPaymentAmount(loanData).toLocaleString('en-US')}
                            </span>
                        </Grid>}
                        {(loanData.Defaulted || loanData.MissedPayments > 0) && <Grid item xs={12}>
                            <br />
                            <b>{
                                loanData.Defaulted 
                                ? `This loan has been defaulted because you missed to many payments. The asset(s) relating to this loan have been seized temporarily until you pay the amount missed. Failing to pay within a month of the loan being defaulted, your asset(s) are at high risk of being permanently seized.` 
                                : loanData.MissedPayments > 0
                                && `You have missed the last ${loanData.MissedPayments > 1 ? `${loanData.MissedPayments} payments` : 'payment'} for this loan. If ${loanData.MissablePayments} consecutive payments are missed, the loan will be defaulted on and the asset(s) relating to this loan will be seized.`
                            }</b>
                        </Grid>}
                    </Grid>}
                </AppBar>
                {loading ? <Loader static text={"Completing Loan Payment..."} /> : loanData ?
                    <div className={classes.accountBody}>
                        {
                            loanData.Defaulted ? <Grid container>
                                <Grid item xs={12} className={classes.accountBtn} onClick={() => openWeeklyPayment()}>
                                    <div className={classes.content}>
                                        <Grid container direction="row" justifyContent="center" alignItems="center">
                                            <Grid item xs={2}>
                                                <FontAwesomeIcon icon={['fas', 'sack-dollar']} />
                                            </Grid>
                                            <Grid item xs={10}>
                                                Pay Loan Debt
                                            </Grid>
                                        </Grid>
                                    </div>
                                </Grid>
                            </Grid>
                            : <Grid container>
                                <Grid item xs={12} className={classes.accountBtn} onClick={() => openWeeklyPayment()}>
                                    <div className={classes.content}>
                                        <Grid container direction="row" justifyContent="center" alignItems="center">
                                            <Grid item xs={2}>
                                                <FontAwesomeIcon icon={['fas', 'circle-dollar']} />
                                            </Grid>
                                            <Grid item xs={10}>
                                                Make Next Payment
                                            </Grid>
                                        </Grid>
                                    </div>
                                </Grid>
                                {/* <Grid item xs={12} className={classes.accountBtn} onClick={() => openWeeklyPayment(true)}>
                                    <div className={classes.content}>
                                        <Grid container direction="row" justifyContent="center" alignItems="center">
                                            <Grid item xs={2}>
                                                <FontAwesomeIcon icon={['fas', 'sack-dollar']} />
                                            </Grid>
                                            <Grid item xs={10}>
                                                Pay In Advanced
                                            </Grid>
                                        </Grid>
                                    </div>
                                </Grid> */}
                            </Grid>
                        }
                    </div> : <p>There was big fuckup oh no.</p>
                }
            </div>
            <Modal
                form
                open={weeklyPayment}
                title={`Loan Payment - $${getNextPaymentAmount(loanData, WPState.weeks).toLocaleString('en-US')}`}
                submitLang="Make Payment"
                closeLang="Cancel"
                onAccept={makeWeeklyPayment}
                onClose={() => setWeeklyPayment(false)}
            >
                <p className={classes.editField}>
                    Loan Payments are taken from your Personal Checking Account.
                    Due Payment: ${getNextPaymentAmount(loanData, WPState.weeks).toLocaleString('en-US')}.
                </p>
                {/* {WPState.allowAhead && <TextField
                    type="number"
                    required
                    fullWidth
                    className={classes.editField}
                    label="Amount of Payments Ahead"
                    name="weeks"
                    value={WPState.weeks}
                    onChange={onWPChange}
                    helperText="The number of weeks worth of payments to make."
                    inputProps={{
                        type: 'number',
                        min: 1,
                        max: (loanData.TotalPayments - loanData.PaidPayments),
                        maxLength: 4,
                    }}
                />} */}
            </Modal>
        </>
    );
};

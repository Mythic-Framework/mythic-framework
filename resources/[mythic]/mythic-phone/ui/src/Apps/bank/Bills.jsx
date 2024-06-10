import React, { useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { List, ListItem, ListItemText, ListItemSecondaryAction, IconButton, TextField, FormControl, Select, MenuItem, FormHelperText } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';

import Nui from '../../util/Nui';
import { useAlert } from '../../hooks';
import { Modal } from '../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	emptyLogo: {
		width: '100%',
		fontSize: 170,
		textAlign: 'center',
		marginTop: '25%',
		color: `#30518c29`,
	},
	emptyMsg: {
		color: theme.palette.text.alt,
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
	},
    listItem: {
        background: theme.palette.secondary.dark,
        borderRadius: 5,
		boxShadow: '0px 0px 12px -2px rgba(0,0,0,0.3)',
        marginBottom: '5%',
    },
    successText: {
        color: theme.palette.success.main,
    },
    errorText: {
        color: theme.palette.error.light,
    },
    editField: {
		marginBottom: 20,
		width: '100%',
	},
}));

export default connect()((props) => {
	const classes = useStyles();
    const showAlert = useAlert();
    const bankData = useSelector((state) => state.data.data.bankAccounts);
    const myAccounts = bankData?.accounts;
	const pendingBills = bankData?.pendingBills;

    const personalAccount = myAccounts && myAccounts.filter((acc) => acc.Type == 'personal')[0];

    const [acceptBilling, setAcceptBilling] = useState(false);
	const [bState, setBState] = useState({
        bill: 0,
        withAccount: personalAccount.Account,
	});

    const onBChange = (e) => {
		setBState({
			...bState,
			[e.target.name]: e.target.value,
		});
	};

    const openAcceptBilling = (bill) => {
        setBState({
            billData: bill,
            billId: bill.Id,
            withAccount: personalAccount.Account,
        });
		setAcceptBilling(true);
	}

    const onAcceptBill = async (e) => {
		e.preventDefault();
        props.setLoading('Accepting Bill');

        const payingAccount = myAccounts && myAccounts.filter((acc) => acc.Account == bState.withAccount)[0];
        if (payingAccount && payingAccount.Balance >= bState?.billData.Amount) {
            try {
                let res = await (await Nui.send('Banking:AcceptBill', {
                    bill: bState.billId,
                    account: bState.withAccount,
                })).json();
                if (res) {
                    showAlert('Bill Has Been Paid');
                } else {
                    showAlert('Error Paying Bill');
                }
                setTimeout(() => props.refreshAccounts(), 750);
            } catch (err) {
                showAlert('Error Paying Bill');
                props.setLoading(false);
            }

            setAcceptBilling(false);
            setBState({
                bill: 0,
                withAccount: personalAccount.Account,
            });
        } else {
            showAlert('Insufficient Funds to Pay Bill');
            props.setLoading(false);
        }
	};

    const onDenyBill = async (bill) => {
        props.setLoading('Dismissing Bill');
        try {
            let res = await (await Nui.send('Banking:DismissBill', {
                bill: bill.Id,
            })).json();
            if (res) {
                showAlert('Bill Has Been Dismissed');
                setTimeout(() => {
                    props.refreshAccounts();
                }, 750);
            } else {
                showAlert('Error Dismissing Bill');
                props.setLoading(false);
            }
        } catch (err) {
            showAlert('Error Dismissing Bill');
            props.setLoading(false);
        }
    }

    const getAccountName = (acc) => {
		switch(acc.Type) {
			case 'personal':
				return 'Personal Account';
			case 'personal_savings':
				return 'Personal Savings Account'
			default:
				return acc.Name;
		}
	}

    if (pendingBills.length > 0) {
        return <div className={classes.wrapper}>
            <div>
                <List>
                    {pendingBills.sort((a, b) => b.Timestamp - a.Timestamp).map((bill) => {
                        return <ListItem key={bill.Id} className={classes.listItem}>
                            <ListItemText
                                primary={<span><span className={classes.successText}>${bill.Amount}</span> - {bill.Name}</span>}
                                secondary={
                                    <span>
                                        {bill.Account && <span>Account Number: {bill.Account}.<br /></span>}
                                        Received <Moment unix date={bill.Timestamp} fromNow />.
                                        <br /><br />
                                        {bill.Description}
                                    </span>
                                }
                                secondaryTypographyProps={{
                                    maxWidth: '85%',
                                }}
                            />
                            <ListItemSecondaryAction>
                                <IconButton className={classes.errorText} onClick={() => onDenyBill(bill)}>
                                    <FontAwesomeIcon
                                        icon={['fas', 'xmark']}
                                    />
                                </IconButton>
                                <IconButton className={classes.successText} onClick={() => openAcceptBilling(bill)}>
                                    <FontAwesomeIcon
                                        icon={['fas', 'check']}
                                    />
                                </IconButton>
                            </ListItemSecondaryAction>
                        </ListItem>
                    })}
                </List>
            </div>
            <Modal
                form
                open={acceptBilling}
                title={`Accept Bill of $${bState.billData?.Amount}`}
                submitLang="Accept Bill"
                onAccept={onAcceptBill}
                onClose={() => setAcceptBilling(false)}
            >
                <FormControl className={classes.editField}>
                    <Select
                        id="withAccount"
                        name="withAccount"
                        value={bState.withAccount}
                        onChange={onBChange}
                    >
                        {myAccounts.map((account) => {
                            return <MenuItem 
                                key={account.Account} 
                                value={account.Account}
                                disabled={!account.Permissions?.WITHDRAW}
                            >
                                {`${getAccountName(account)} - ${account.Account}`}
                            </MenuItem>
                        })}
                    </Select>
                    <FormHelperText>Select the account that you wish to pay with.</FormHelperText>
                </FormControl>
            </Modal>
        </div>
    } else {
        return <div className={classes.wrapper}>
            <div className={classes.emptyLogo}>
                <FontAwesomeIcon icon={['fas', 'tree-palm']} />
            </div>
            <div className={classes.emptyMsg}>
                No Pending Bills
            </div>
        </div>
    }
});

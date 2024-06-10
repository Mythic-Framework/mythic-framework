export const getAccountName = (accountData) => {
	switch (accountData.Type) {
		case 'personal':
			return 'Checking Account';
		case 'personal_savings':
			return 'Savings Account';
		default:
			return accountData.Name;
	}
};

export const getAccountType = (accountData) => {
	switch (accountData.Type) {
		case 'personal':
			return 'Checking Account';
		case 'personal_savings':
			return 'Savings Account';
		case 'organization':
			return 'Organization Account';
		default:
			return 'Bank Account';
	}
};

export const getLoanTypeName = (type) => {
	switch (type) {
		case 'vehicle':
			return 'Vehicle';
		case 'property':
			return 'Property';
		default:
			return 'Asset';
	}
};

export const getLoanIdentifierType = (type) => {
	switch (type) {
		case 'vehicle':
			return 'Vehicle VIN';
		case 'property':
			return 'Property ID';
		default:
			return 'Asset ID';
	}
};

export const getActualRemainingAmount = (loanData) => {
	if (loanData.Remaining > 0) {
		const interestMult = (100 + loanData.InterestRate) / 100;
		return Math.ceil(loanData.Remaining * interestMult);
	} else {
		return 0;
	}
};

export const getNextPaymentAmount = (loanData, weeksOverride = 1) => {
	if (loanData.Remaining > 0) {
		const interestMult = (100 + loanData.InterestRate) / 100;
		const remainingPayments =
			loanData.TotalPayments - loanData.PaidPayments;

		if (loanData.MissedPayments > 1) {
			if (weeksOverride === 1) {
				weeksOverride = loanData.MissedPayments;
			}
		}

		if (weeksOverride > remainingPayments) {
			weeksOverride = remainingPayments;
		}

		const eachPayment = loanData.Remaining / remainingPayments;
		const amount = eachPayment * weeksOverride * interestMult;
		return Math.ceil(amount);
	} else {
		return 0;
	}
};

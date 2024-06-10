export const getAccountName = (accountData) => {
    switch(accountData.Type) {
        case 'personal':
            return 'Current Account';
        case 'personal_savings':
            return 'Savings Account';
        default:
            return accountData.Name;
    }
}

export const getAccountType = (accountData) => {
    switch(accountData.Type) {
        case 'personal':
            return 'Current Account';
        case 'personal_savings': 
            return 'Savings Account';
        case 'organization':
            return 'Organization Account';
        default:
            return 'Bank Account';
    }
}
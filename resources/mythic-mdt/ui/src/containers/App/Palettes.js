export const GetDeptPalette = (workplace, theme) => {
	switch (workplace) {
		case 'lspd':
			return LSPDPalette(theme);
		case 'lscso':
			return LSCSOPalette(theme);
		case 'doj':
		case 'dattorney':
		case 'mayoroffice':
			return DOJPalette(theme);
		case 'safd':
			return MedicalPalette(theme);
		case 'doctors':
			return MedicalPalette(theme);
		default:
			return StandardPalette(theme);
	}
};

export const LSPDPalette = (theme) => {
	return {
		...StandardPalette(theme),
		primary: {
			main: '#f9c334',
			light: '#ecc96a',
			dark: '#9c791b',
			contrastText: theme === 'dark' ? '#ffffff' : '#26292d',
		},
		secondary: {
			main: theme === 'dark' ? '#172c42' : '#ffffff',
			light: theme === 'dark' ? '#233e5a' : '#F5F6F4',
			dark: theme === 'dark' ? '#0d1721' : '#EBEBEB',
			contrastText: theme === 'dark' ? '#ffffff' : '#2e2e2e',
		},
	};
};

export const LSCSOPalette = (theme) => {
	return {
		...StandardPalette(theme),
		primary: {
			main: '#4a93b7',
			light: '#7ec3e9',
			dark: '#016587',
			contrastText: theme === 'dark' ? '#ffffff' : '#26292d',
		},
		secondary: {
			main: theme === 'dark' ? '#2e2e2e' : '#ffffff',
			light: theme === 'dark' ? '#121212' : '#F5F6F4',
			dark: theme === 'dark' ? '#151515' : '#EBEBEB',
			contrastText: theme === 'dark' ? '#ffffff' : '#2e2e2e',
		},
	};
};

export const DOJPalette = (theme) => {
	return {
		...StandardPalette(theme),
		primary: {
			main: '#009688',
			light: '#52c7b8',
			dark: '#00675b',
			contrastText: theme === 'dark' ? '#ffffff' : '#26292d',
		},
		secondary: {
			main: theme === 'dark' ? '#1e1e1e' : '#ffffff',
			light: theme === 'dark' ? '#313131' : '#F5F6F4',
			dark: theme === 'dark' ? '#151515' : '#EBEBEB',
			contrastText: theme === 'dark' ? '#ffffff' : '#2e2e2e',
		},
	};
};

export const MedicalPalette = (theme) => {
	return {
		...StandardPalette(theme),
		primary: {
			main: '#395475',
			light: '#6780a4',
			dark: '#072c49',
			contrastText: theme === 'dark' ? '#ffffff' : '#26292d',
		},
		secondary: {
			main: theme === 'dark' ? '#1e1e1e' : '#ffffff',
			light: theme === 'dark' ? '#313131' : '#F5F6F4',
			dark: theme === 'dark' ? '#151515' : '#EBEBEB',
			contrastText: theme === 'dark' ? '#ffffff' : '#2e2e2e',
		},
	};
};

export const StandardPalette = (theme) => {
	return {
		primary: {
			main: '#8a0000',
			light: '#ff2100',
			dark: '#560000',
			contrastText: '#ffffff',
		},
		secondary: {
			main: '#141414',
			light: '#1c1c1c',
			dark: '#0f0f0f',
			contrastText: '#ffffff',
		},
		error: {
			main: '#6e1616',
			light: '#a13434',
			dark: '#430b0b',
		},
		success: {
			main: '#52984a',
			light: '#60eb50',
			dark: '#244a20',
		},
		warning: {
			main: '#f09348',
			light: '#f2b583',
			dark: '#b05d1a',
		},
		info: {
			main: '#247ba5',
			light: '#247ba5',
			dark: '#175878',
		},
		text: {
			main: theme === 'dark' ? '#ffffff' : '#2e2e2e',
			alt: theme === 'dark' ? 'rgba(255, 255, 255, 0.7)' : '#858585',
			info: theme === 'dark' ? '#919191' : '#919191',
			light: '#ffffff',
			dark: '#000000',
		},
		alt: {
			green: '#008442',
			greenDark: '#064224',
		},
		border: {
			main: theme === 'dark' ? '#e0e0e008' : '#e0e0e008',
			light: '#ffffff',
			dark: '#26292d',
			input:
				theme === 'dark'
					? 'rgba(255, 255, 255, 0.23)'
					: 'rgba(0, 0, 0, 0.23)',
			divider:
				theme === 'dark'
					? 'rgba(255, 255, 255, 0.12)'
					: 'rgba(0, 0, 0, 0.12)',
		},
		mode: theme,
	};
};

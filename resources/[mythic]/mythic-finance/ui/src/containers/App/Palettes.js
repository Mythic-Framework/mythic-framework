export default (brand, theme) => {
	switch (brand) {
		case 'fleeca':
			return Fleeca(theme);
		case 'maze':
		case 'blaineco':
		default:
			return StandardPalette(theme);
	}
};

export const Fleeca = (theme) => {
	return {
		...StandardPalette(theme),
		primary: {
			main: '#25883d',
			light: '#51c46d',
			dark: '#124f21',
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

export const Maze = (theme) => {
	return {
		...StandardPalette(theme),
		primary: {
			main: '#ee222e',
			light: '#f28f95',
			dark: '#840008',
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

export const BlaineCo = (theme) => {
	return {
		...StandardPalette(theme),
		primary: {
			main: '#921b1f',
			light: '#d45054',
			dark: '#921b1f',
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
			main: '#de3333',
			light: '#ff6060',
			dark: '#941a1a',
			contrastText: '#ffffff',
		},
		secondary: {
			main: '#13141f',
			light: '#1b1c2c',
			dark: '#11121b',
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
			main: '#ffffff',
			alt: '#A7A7A7',
			info: '#919191',
			light: '#ffffff',
			dark: '#000000',
		},
		border: {
			main: '#e0e0e008',
			light: '#ffffff',
			dark: '#26292d',
			input: 'rgba(255, 255, 255, 0.23)',
			divider: 'rgba(255, 255, 255, 0.12)',
			item: 'rgb(255, 255, 255)',
		},
		mode: 'dark',
	};
};

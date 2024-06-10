import parse from 'parse-duration';
import sanitizeHtml from 'sanitize-html';

export const Sanitize = (dirty) => {
    return sanitizeHtml(dirty, {
        allowedTags: [
            'b',
            'i',
            'em',
            'strong',
            'img',
            'h1',
            'h2',
            'h3',
            'h4',
            'h5',
            'h6',
            'blockquote',
            'pre',
            'ol',
            'ul',
            'li',
            'p',
            'div',
            'br',
        ],
        allowedAttributes: {
            img: ['src', 'alt', 'height', 'width'],
        },
    });
};

const zeroPad = (nr, base) => {
	var len = String(base).length - String(nr).length + 1;
	return len > 0 ? new Array(len).join('0') + nr : nr;
};

export const FormatThousands = (input) => {
	return input.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
};

export const TranslateWeapon = (input) => {};

const DAY_MS = 1000 * 60 * 60 * 24;
const HOUR_MS = 1000 * 60 * 60;
const MIN_MS = 1000 * 60;

export const DurationToTime = (ms) => {
	let days = Math.floor(ms / DAY_MS);
	let hours = Math.floor((ms - (DAY_MS * days)) / HOUR_MS);
	let minutes = Math.floor((ms - ((DAY_MS * days) + (HOUR_MS * hours))) / MIN_MS);
	let seconds = Math.floor(ms % 1000);

	let str = Array();

	if (days > 0) {
		str.push(`${days} ${days == 1 ? 'Day' : 'Days'}`);
	}

	if (hours > 0 && hours < 24) {
		str.push(`${hours} ${hours == 1 ? 'Hour' : 'Hours'}`);
	}

	if (minutes > 0 && hours < 60) {
		str.push(`${minutes} ${minutes == 1 ? 'Minute' : 'Minutes'}`);
	}

	if (seconds > 0 && seconds < 60) {
		str.push(`${seconds} ${seconds == 1 ? 'Second' : 'Seconds'}`);
	}

	return str.join(' ');
};

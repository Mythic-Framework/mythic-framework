/**
 * @see https://github.com/remarkablemark/html-react-parser/issues/94
 */
 import DOMPurify from 'dompurify';
 import parse from 'html-react-parser';
 
 export const Sanitize = (html) => {
     return parse(DOMPurify.sanitize(html));
 };
 
 export const Slugify = (input) => {
     return input
         .toLowerCase()
         .replace(/ /g, '-')
         .replace(/[^\w-]+/g, '');
 };
 
 export const CurrencyFormat = new Intl.NumberFormat('en-US', {
     style: 'currency',
     currency: 'USD',
 
     // These options are needed to round to whole numbers if that's what you want.
     //minimumFractionDigits: 0, // (this suffices for whole numbers, but will print 2500.10 as $2,500.1)
     //maximumFractionDigits: 0, // (causes 2500.99 to be printed as $2,501)
 });
 
 export const TitleCase = (str) => {
     return str.replace(/\w\S*/g, function (txt) {
         return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
     });
 };
 
/**
 * @see https://github.com/remarkablemark/html-react-parser/issues/94
 */
const { renderToStaticMarkup } = require('react-dom/server');
const DOMPurify = require('dompurify');
const parse = require('html-react-parser');

export const Sanitize = (html) => {
    return parse(DOMPurify.sanitize(html));
}
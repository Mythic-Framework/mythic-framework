/**
 * @see https://github.com/remarkablemark/html-react-parser/issues/94
 */
import DOMPurify from 'dompurify';
import parse from 'html-react-parser';

export const Sanitize = (html) => {
    return parse(DOMPurify.sanitize(html));
};

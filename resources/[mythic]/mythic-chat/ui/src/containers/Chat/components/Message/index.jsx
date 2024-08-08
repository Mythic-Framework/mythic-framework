import React from 'react';
import {
    Default,
    OOC,
    Server,
    PDDispatch,
    EMSDispatch,
    Dispatch,
    TestResults,
} from './Templates';

export default ({ message }) => {
    const getMessageTemplate = () => {
        if (!Boolean(message.message)) return null;

        switch (message.type) {
            case 'ooc':
                return <OOC message={message} />;
            case 'server':
                return <Server message={message} />;
            case '911':
                return <PDDispatch message={message} />;
            case '311':
                return <EMSDispatch message={message} />;
            case 'dispatch':
                return <Dispatch message={message} />;
            case 'tests':
                return <TestResults message={message} />;
            case 'system':
                return <Default message={message} />;
        }
    };

    return <>{getMessageTemplate()}</>;
};

import { useEffect, useRef } from 'react';

export default function useInterval(callback, delay) {
    const savedCallback = useRef();


    useEffect(() => {
        savedCallback.current = callback;
    }, [callback]);

    useEffect(() => {
        function tick() {
            if (savedCallback.current) {
                savedCallback.current();
            }
        }
        if (delay !== null && delay !== undefined) {
            let id = setInterval(tick, delay);
            return () => clearInterval(id);
        }
    }, [delay]);
}

import React, { useEffect, useState, useCallback, useRef } from 'react';
import { throttle } from 'lodash';
import { useSelector } from 'react-redux';
import Nui from '../../util/Nui';

const CameraControls = ({ isDisabled, children }) => {
    const state = useSelector((state) => state.app.state);
    const [isDragging, setIsDragging] = useState(false);
    const [lastMousePosition, setLastMousePosition] = useState({ x: 0, y: 0 });
    const [insideCustomDiv, setInsideCustomDiv] = useState(false);
    const [moveOverBwo, setMoveOverBwo] = useState(true);

    const customDivRef = useRef(null);

    const rotate = useCallback(
        throttle((dir) => {
            Nui.send(`Rotate${dir}`);
        }, 50),
        []
    );

    const checkIfInsideCustomDiv = (event) => {
        const rect = customDivRef.current.getBoundingClientRect();
        const isInside = (
            event.clientX >= rect.left &&
            event.clientX <= rect.right &&
            event.clientY >= rect.top &&
            event.clientY <= rect.bottom
        );
        setInsideCustomDiv(isInside);
    };

    const handleDown = (event) => {
        checkIfInsideCustomDiv(event);

        if (event.keyCode === 81) {
            rotate('Left');
        } else if (event.keyCode === 69) {
            rotate('Right');
        }
    };

    const handleUp = (event) => {
        checkIfInsideCustomDiv(event);

        if (event.keyCode === 82) {
            Nui.send('Animation');
        }
    };

    const handleScroll = (event) => {
        checkIfInsideCustomDiv(event);
        if (isDisabled || !insideCustomDiv) return;
        Nui.send('ZoomCamera', event.deltaY > 0 ? 'forward' : 'back');
    };

    const handleMouseDown = (event) => {
        checkIfInsideCustomDiv(event);
        if (isDisabled || !insideCustomDiv) return;

        setIsDragging(true);
        setLastMousePosition({ x: event.clientX, y: event.clientY });
    };

    const handleMouseUp = (event) => {
        checkIfInsideCustomDiv(event);
        if (isDisabled || !insideCustomDiv) return;

        setIsDragging(false);
    };

    const handleMouseMove = (event) => {
        checkIfInsideCustomDiv(event);
        if (isDisabled || !insideCustomDiv || !isDragging) return;

        const deltaX = event.clientX - lastMousePosition.x;
        const deltaY = event.clientY - lastMousePosition.y;

        Nui.send('DragCamera', {
            x: deltaX / 1,
            y: deltaY / 1,
        });

        setLastMousePosition({ x: event.clientX, y: event.clientY });
    };

    useEffect(() => {
        window.addEventListener('keydown', handleDown);
        window.addEventListener('keyup', handleUp);
        window.addEventListener('wheel', handleScroll);
        window.addEventListener('mousedown', handleMouseDown);
        window.addEventListener('mouseup', handleMouseUp);
        window.addEventListener('mousemove', handleMouseMove);

        return () => {
            window.removeEventListener('keydown', handleDown);
            window.removeEventListener('keyup', handleUp);
            window.removeEventListener('wheel', handleScroll);
            window.removeEventListener('mousedown', handleMouseDown);
            window.removeEventListener('mouseup', handleMouseUp);
            window.removeEventListener('mousemove', handleMouseMove);
        };
    }, [isDragging, lastMousePosition, isDisabled, insideCustomDiv]);

    useEffect(() => { // btnBar in the tattoos isnt needed so i hid it, and have this to move the camera block div, so you can scroll on panel without it moving the camera.
        if (state === 'TATTOO') {
            setMoveOverBwo(true);
        } else {
            setMoveOverBwo(false);
        }
    }, [state]);

    if (!React.Children.count(children)) {
        return null;
    }

    return (
        <>
            {React.Children.only(children)}
            {/* <div ref={customDivRef} style={{ position: 'absolute', top: 48, left: moveOverBwo ? 500 : 590, width: '100%', height: '90vh', background: 'rgba(0, 0, 0, .5)', zIndex: 0 }} /> */}
            <div
                ref={customDivRef}
                style={{
                    position: 'absolute',
                    top: 48,
                    left: moveOverBwo ? 500 : 590,
                    width: '100%',
                    height: '90vh',
                    background: 'rgba(0, 0, 0, 0)',
                    zIndex: 0,
                    cursor: 'grab',
                    caretColor: 'red',
                }}
                onMouseDown={() => customDivRef.current.style.cursor = 'grabbing'}
                onMouseUp={() => customDivRef.current.style.cursor = 'grab'}
            />

        </>
    );
};

export default CameraControls;

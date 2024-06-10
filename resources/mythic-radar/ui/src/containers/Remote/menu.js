export default [
    { 
        setting: 'fastSpeed', 
        radar: 'FST',
        fast: 'SPD',
        min: 20, 
        max: 150, 
        step: 5, 
        labeledIndex: {
            20: 'OFF'
        }
    },
    { 
        setting: 'location',
        radar: 'RAD',
        fast: 'POS',
        min: 1,
        max: 7,
        step: 1,
        labeledIndex: {
            1: 'BR',
            2: 'R',
            3: 'TR',
            4: 'TOP',
            5: 'TL',
            6: 'L',
            7: 'BL',
        }
    },
    { 
        setting: 'scale',
        radar: 'SCA',
        fast: 'LE',
        min: 85,
        max: 200,
        step: 5 
    },
];
const penis = document.getElementById('penis');

function updateLink(link) {
    if (link && link?.length > 0) {
        penis.innerHTML = `<img src="${link}" />`;
    } else {
        penis.innerHTML = ``;
    }
};

setTimeout(() => {
    
}, 10);

window.addEventListener('message', e => {
    const item = e.data || e.detail;
    const { event, data } = item;
    if (event) {
        switch(event) {
            default:
            case 'updateLink':
                updateLink(data);
                break;
        }
    }
}, false);



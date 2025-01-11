toggleUi(false);

window.addEventListener('message', (event) => {
    let data = event.data;
    let action = data.action;

    switch (action) {
        case 'toggleUi':
            toggleUi(data.bool, data.isInFunk);
            break;
    }
});

document.addEventListener('keydown', (event) => {
    if (event.key == 'Escape') {
        toggleUi(false, null);
        $.post(`https://${GetParentResourceName()}/close`);
    }
});

$('.btn-frak').click(() => {
    $.post(`https://${GetParentResourceName()}/frak`, (cb) => {
        if (cb) {
            toggleUi(true, true);
        }
    });
});

$('.btn-join').click(() => {
    const funk = $('.funk-input').val();

    $.post(
        `https://${GetParentResourceName()}/join`,
        JSON.stringify({
            funk: funk,
        }),
        (cb) => {
            if (cb) {
                toggleUi(true, true);
            }
        },
    );
});

$('.btn-leave').click(() => {
    $.post(`https://${GetParentResourceName()}/leave`);
    toggleUi(true, false);
});

function toggleUi(bool, isInFunk) {
    if (isInFunk != null) {
        $('.btn-join').hide();
        $('.btn-leave').hide();

        isInFunk ? $('.btn-leave').show() : $('.btn-join').show();
    }

    bool ? $('.form').fadeIn(250) : $('.form').fadeOut(250);
}

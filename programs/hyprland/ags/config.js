function Bar(monitor = 0) {
    const myLabel = Widget.Label({
        label: 'some example content',
    })

    return Widget.Window({
        monitor,
        name: `bar${monitor}`, // this name has to be unique
        anchor: ['top', 'left', 'right'],
        child: myLabel,
    })
}

export default {
    windows: [
        Bar(0), // can be instantiated for each monitor
        Bar(1),
    ],
}

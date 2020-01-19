tag App

    def listDevices
        let device = await global:navigator:bluetooth.requestDevice({
            filters: [{
                services: [0x1801, 0x1800, 'ab0828b1-198e-4351-b779-901fa0e0371e']
            }]
        })
        console.log device
        let server = await device:gatt.connect()
        console.log server
        let services = await server.getPrimaryServices()
        console.log services
        # for service in services
        #     console.log(services);
        #     let characteristics = await service.getCharacteristics()
        #     console.log(characteristics);
        #     for char in characteristics
        #         console.log(console.log(char));

    def render
        <self>
            <button style="width: 200px; height: 200px" :tap.listDevices>
                "BLE TEST"

Imba.mount <App>

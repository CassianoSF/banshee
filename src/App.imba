tag App

    def listDevices
        let device = await global:navigator:bluetooth.requestDevice({
            acceptAllDevices: yes
        })
        let server = await device:gatt.connect()
        let services = await server.getPrimaryServices()
        console.log(services);
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

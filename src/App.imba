console.log "VERSÃO 0.0.7"

tag App

    prop response default: ''
    prop value
    prop notifier
    prop writer

    def connect
        let device = await global:navigator:bluetooth.requestDevice({
            acceptAllDevices: true
            optionalServices: ['ab0828b1-198e-4351-b779-901fa0e0371e']
        })
        let server = await device:gatt.connect()
        console.log server
        let services = await server.getPrimaryService('ab0828b1-198e-4351-b779-901fa0e0371e')
        console.log service
        
        let char_notifier = await service.getCharacteristic('4ac8a682-9736-4e5d-932b-e9b31405049c')
        console.log char_notifier
        char_notifier.addEventListener('characteristicvaluechanged', &) do |e| 
            console.log(e)
            response = e:target:value.getUint8(0)
            console.log response

        let char_writer = await service.getCharacteristic('23bf1882-3af7-11ea-b77f-2e728ce88125')
        console.log char_writer
        writer = await getDescriptor('gatt.characteristic_user_description')
        console.log writer

    def write
        return unless writer
        let encoder = TextEncoder.new('utf-8');
        console.log(
            await writer.writeValue(encoder.encode(value))
        )

    def render
        <self>
            <button style="width: 200px; height: 100px;" :tap.connect>
                "Connect"
            <textarea[value] style="width: 200px; height: 100px;">
            <button style="width: 200px; height: 100px" :tap.write>
                "Write"
            <div>
                response

Imba.mount <App>

console.log "VERSÃO 0.0.29"

const SERVICE_UUID = 'ab0828b1-198e-4351-b779-901fa0e0371e'
const CHARACTERISTIC_UUID_RX = '4ac8a682-9736-4e5d-932b-e9b31405049c'
const CHARACTERISTIC_UUID_TX = '23bf1882-3af7-11ea-b77f-2e728ce88125'

tag App

    prop response default: ''
    prop value
    prop attr_notifier
    prop attr_writer

    def connect
        try
            let device = await global:navigator:bluetooth.requestDevice({
                acceptAllDevices: true
                optionalServices: [SERVICE_UUID]
            })
            let server = await device:gatt.connect()
            let service = await server.getPrimaryService(SERVICE_UUID)
            
            attr_notifier = await service.getCharacteristic(CHARACTERISTIC_UUID_TX)
            console.log attr_notifier
            attr_notifier.oncharacteristicvaluechanged = do |e|
                console.log(e, 'event')
                response = e:target:value.getUint8(0)
                render

            attr_writer = await service.getCharacteristic(CHARACTERISTIC_UUID_RX)
            console.log attr_writer

        catch err
            console.log err

    def write
        try
            return unless attr_writer
            let enc = TextEncoder.new('utf-8')
            attr_writer.writeValue(enc.encode(value))

        catch err
            console.log err


    def render
        <self .card>
            <div .card-body>
                <button .btn style="width: 100%; height: 100px;" :tap.connect>
                    "Connect"
                <input[value] .form-control .form-control-lg .feedback style="width:100%;height:100px;background-color:black;color:white">
                <button .btn style="width: 100%; height: 100px" :tap.write>
                    "Write"
                        response
                <input[response] disabled .form-control .form-control-lg .feedback style="width:100%;height:100px;background-color:black;color:white">

Imba.mount <App>

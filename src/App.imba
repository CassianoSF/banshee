console.log "VERSÃO 0.0.19"

tag App

    prop response default: ''
    prop value
    prop char_notifier
    prop writer

    def connect
        try
            let device = await global:navigator:bluetooth.requestDevice({
                acceptAllDevices: true
                optionalServices: ['ab0828b1-198e-4351-b779-901fa0e0371e']
            })
            let server = await device:gatt.connect()
            console.log server
            let service = await server.getPrimaryService('ab0828b1-198e-4351-b779-901fa0e0371e')
            console.log service
            
            char_notifier = await service.getCharacteristic('23bf1882-3af7-11ea-b77f-2e728ce88125')
            console.log char_notifier
            char_notifier.addEventListener('characteristicvaluechanged', &) do |e| 
                console.log(e)
                response = e:target:value.getUint8(0)
                console.log response

            let char_writer = await service.getCharacteristic('4ac8a682-9736-4e5d-932b-e9b31405049c')
            console.log char_writer
            writer = await char_writer.getDescriptor('gatt.characteristic_user_description')
            console.log writer
        catch err
            console.log err

    def write
        try
            return unless writer
            let encoder = TextEncoder.new('utf-8');
            let test = await writer.writeValue(0xFFFFFF)
            console.log test
        catch err
            console.log err

    # def tick
    #     schedule interval: 100
    #     if char_notifier
    #         let test = await char_notifier.readValue
    #         console.log test
    #     render


    def render
        <self .content>
            <div .card>
                <div .card-body>
                    <button .btn style="width: 100%; height: 100px;" :tap.connect>
                        "Connect"
                    <input[value] .form-control .form-control-lg .feedback style="width:100%;height:100px;background-color:black;color:white">
                    <button .btn style="width: 100%; height: 100px" :tap.write>
                        "Write"
                            response
                    <input[response] disabled .form-control .form-control-lg .feedback style="width:100%;height:100px;background-color:black;color:white">

Imba.mount <App>

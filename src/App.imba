console.log "VERSÃO 0.0.41"

const SERVICE_UUID = 'ab0828b1-198e-4351-b779-901fa0e0371e'
const CHARACTERISTIC_UUID_RX = '4ac8a682-9736-4e5d-932b-e9b31405049c'
const CHARACTERISTIC_UUID_TX = '23bf1882-3af7-11ea-b77f-2e728ce88125'

const Highcharts = require('highcharts')

Oscillator = DSP:Oscillator
SINEWAVE   = DSP:SINEWAVE
SQUAREWAVE = 4
FFT        = DSP:FFT
IIRFilter  = DSP:IIRFilter
LOWPASS    = DSP:LOWPASS

tag App
	def mount
		@samples = 2**12
		@rate = 4
		@samples-rate = @samples * @rate

		let oscs = [
			Oscillator.new(SINEWAVE, 20, 10, @samples,  @samples-rate)
			Oscillator.new(SINEWAVE, 200, 5, @samples,  @samples-rate)
			Oscillator.new(SINEWAVE, 300, 2, @samples, @samples-rate)
		]
		oscs.map do |o| o.generate

		let waves = oscs.map do |o| o:signal
		@signal = for i in [0...@samples]
			waves[0][i] + waves[1][i] + waves[2][i]

		let fft = FFT.new(@samples, @samples-rate)
		fft.forward(@signal)
		@spectrum = for val, index in fft:spectrum
			[index * @rate, val]


		plotChart('signal',     'Signal',   @signal)
		plotChart('signal-fft', 'Spectrum', @spectrum.slice(0,100))


		var filter = IIRFilter.new(LOWPASS, 25, 4, @samples-rate)
		filter.process(@signal)
		fft.forward(@signal)
		@spectrum = for val, index in fft:spectrum
			[index * @rate, val]

		plotChart('result',     'Result',   @signal)
		plotChart('result-fft', 'Spectrum', @spectrum.slice(0,100))



	def plotChart id, title, data
		Highcharts.chart(id, {
			title: 
				text: title
			series: [{
				data: Array.from(data)
			}]
		})

	def render
		<self>
			<.row>
				<.col-md-6>
					<#signal>
				<.col-md-6>
					<#signal-fft>
			<.row>
				<.col-md-6>
					<#filter>
				<.col-md-6>
					<#filter-fft>
			<.row>
				<.col-md-6>
					<#result>
				<.col-md-6>
					<#result-fft>
			# <Bluetooth>

tag Bluetooth
	prop response default: ''
	prop value
	prop attr_notifier
	prop attr_writer
	prop encoder default: TextEncoder.new('utf-8')
	prop decoder default: TextDecoder.new('utf-8')
	prop ready

	def mount
		schedule interval: 100
		render

	def tick # executa a cada 100ms
		if ready
			try await read 
		render


	def connect
		let device = await global:navigator:bluetooth.requestDevice({
			acceptAllDevices: true
			optionalServices: [SERVICE_UUID]
		})
		let server = await device:gatt.connect()
		let service = await server.getPrimaryService(SERVICE_UUID)
		
		attr_notifier = await service.getCharacteristic(CHARACTERISTIC_UUID_TX)
		console.log attr_notifier

		attr_writer = await service.getCharacteristic(CHARACTERISTIC_UUID_RX)
		console.log attr_writer
		ready = true

	def write
		return unless attr_writer
		attr_writer.writeValue(encoder.encode(value))

	def read
		return unless attr_notifier
		response = decoder.decode(await attr_notifier.readValue)
		console.log response

	def render
		<self .card>
			<div .card-body>
				<button .btn style="width:100%;height:100px" :tap.connect>
					"Connect"
				<div style="height: 500px; width: 100%;background-color: #113;color: #fff;font-size:50px;text-align: center">
					"{Number(response).toFixed(2)}cm"
				# <input[value] .form-control .form-control-lg .feedback style="text-align:center;width:100%;height:60px;background-color:black;color:white">
				# <div .row>
				#     <div .col>
				#         <button .btn style="width:100%;height:100px" :tap.write>
				#             "Write"
				#     <div .col>
				#         <button .btn style="width:100%;height:100px" :tap.read>
				#             "Read"
				# <input[response] disabled .form-control .form-control-lg .feedback style="text-align:center;width:100%;height:100px;background-color:black;color:white">

Imba.mount <App>

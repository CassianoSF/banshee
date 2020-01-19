tag App

	def listDevices
		let test = await global:navigator:bluetooth.requestDevice({
			acceptAllDevices: yes
		})

		console.log test

	def render
		<self>
			<button :tap.listDevices>
				"123"

Imba.mount <App>


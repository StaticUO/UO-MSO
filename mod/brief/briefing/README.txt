
Notes:
	
	1.	With this framework's briefing system, you can create dynamic briefings with dynamic code. All you need to do is 'escape' or break-out out of the briefing with quotes and
		concatenate the string by writing your custom code (usually by using the '+' operator). Example:
		
			<br/>b. Medical Evacuation:
			<br/>
			<br/> " + (if !(isNil "medevac_pilot") then {format["Medivac provided by %1 from FOB Whiskey.", (name medevac_pilot)]} else {"Mission commander's discretion."}) + "
			<br/>
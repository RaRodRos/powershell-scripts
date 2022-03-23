Function Send-Telegram {
	<#
	.DESCRIPTION
		Use a Telegram bot to send a message
	.EXAMPLE
		Send-Telegram -Token "gYOpbbrKT7fgHNYNNvdhOS4XUupku0VZoBKLzsOcxwlhms" -ChatId "00000000" -Message "Hello World"
		Sends "Hello World" through the bot that uses the token to the user with the chat id "00000000"
	.INPUTS
		Bot token, chat Id and message
	.OUTPUTS
		Object with information about the operation and message
	.NOTES
		
	#>
	
	[CmdletBinding()]
	[OutputType([PSCustomObject])]
	[Alias("st")]

	Param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[Alias("t")]
		[String]$Token,

		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[Alias("c")]
		[String]$ChatId,

		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[Alias("m")]
		[String]$Message
	)
	
	begin {
		[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	}
	
	process {
		return Invoke-RestMethod -Uri "https://api.telegram.org/bot${Token}/sendMessage?chat_id=${ChatId}&text=${Message}"
	}
}
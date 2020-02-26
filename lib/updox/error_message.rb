module Updox
  ERROR_CODES = {
    "2000"=>"OK",
    "4000"=>"Bad Request",
    "4010"=>"Unauthorized",
    "4011"=>"Unauthorized [Practice does not exist or is inactive]",
    "4012"=>"Unauthorized [User does not exist or is inactive]",
    "4060"=>"A validation error in the request. For example not including a required field, an invalid e-mail address, too long of a value, etc. A list of the errors is included in the message.",
    "5000"=>"an unknown error has occurred",
    "5100"=>"an unknown server error has occurred",
    "5110"=>"an unknown server error has occurred",
    "4130"=>"account already exists",
    "4110"=>"no practice ID",
    "4160"=>"direct domain is invalid",
    "4621"=>"direct address error: domain does not match the direct domain for this vendor",
    "4150"=>"direct domain is already taken",
    "4163"=>"direct domain is unavailable",
    "4610"=>"direct address error: direct address is taken",
    "4161"=>"web address is invalid",
    "4131"=>"account does not exist",
    "4140"=>"web address is already taken",
    "4230"=>"user already exists",
    "4210"=>"no user ID",
    "4241"=>"invalid user ID, user IDs starting with '@' are reserved for practice users",
    "4251"=>"invalid NPI",
    "4252"=>"invalid taxonomy code",
    "4630"=>"direct address error: account does not have a direct domain configured",
    "4232"=>"user password is required",
    "4240"=>"user does not exist, use practice methods instead",
    "4231"=>"user does not exist",
    "4641"=>"direct address error: sending user does not have a direct address configured",
    "4642"=>"direct address error: identity verification required to send to this address",
    "4640"=>"direct address error: invalid direct address",
    "4650"=>"direct error: send failed",
    "4651"=>"direct error: send failed and/or invalid direct address",
    "4430"=>"message type does not have any MDNs",
    "4410"=>"message not found",
    "4652"=>"direct error: either from or patientDemographics is required",
    "4071"=>"Recipient not found",
    "4070"=>"Invalid recipient",
    "4831"=>"portal account does not exist",
    "4830"=>"portal account already exists",
    "4832"=>"patient has opted out of portal communications",
    "4731"=>"patient account does not exist",
    "4960"=>"image not found",
    "4331"=>"contact does not exist",
    "4931"=>"you sent zero bulk faxes with this bulkFaxId",
    "4021"=>"Invalid date format",
    "4930"=>"no fax found for this ID",
    "4932"=>"fax number does not appear to be available",
    "4933"=>"invalid fax number",
    "4330"=>"contact already exists",
    "6212"=>"at least one id must be specified for the request",
    "4162"=>"ip is invalid",
    "4165"=>"port is invalid",
    "6210"=>"at least one value must be provided",
    "6213"=>"record does not exist for ID",
    "9010"=>"the date format must be in the format is yyyy-MM-dd"
  }
end
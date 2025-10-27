extends LineEdit

func _on_text_changed(new_text: String) -> void:
	# Keep only digits
	var digits := ""
	for character in new_text:
		if character >= "0" and character <= "9":
			digits += character
			
	# Auto-insert dots every 3 digits
	var formatted := ""
	for i in digits.length():
		formatted += digits[i]
		# Add a dot after every 3 digits, but not at the end
		if (i + 1) % 3 == 0 and (i + 1) < digits.length() and (i + 1) < 12:
			formatted += "."
			
	# Cut to max IPv4 length (15 characters)
	if formatted.length() > 15:
		formatted = formatted.substr(0, 15)

	if text != formatted:
		text = formatted
		caret_column = text.length()

# Output behaviour
func _on_text_submitted(submitted_text: String) -> void:
	if _is_valid_ip(submitted_text):
		print("Connecting to:", submitted_text)
	else:
		print("Invalid IP address:", submitted_text)
# same behaviour as pressing enter on lineedit
func _on_join_button_pressed() -> void:
	_on_text_submitted(text)

# Check if IP is still valid
func _is_valid_ip(ip: String) -> bool:
	var parts := ip.split(".")
	if parts.size() != 4:
		return false
	for part in parts:
		if part == "" or not part.is_valid_int():
			return false
		var n := int(part)
		if n < 0 or n > 255:
			return false
	return true

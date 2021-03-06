# Godot Date: Date manipulation and formatting with i18n support
#
# Copyright © 2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Reference

# Used to specify precision in comparisons (from least to most accurate)
enum Precision {
	YEAR,
	MONTH,
	DAY,
	HOUR,
	MINUTE,
	SECOND,
}

var year: int
var month: int
var day: int
var hour: int
var minute: int
var second: int

# The Date instance's locale
# By default, the locale defined in TranslationServer is used
var locale: String setget set_locale

# The locale strings as defined in the locale JSON
var locale_strings: Dictionary

# Creates a new Date instance. Accepted date formats:
# - Godot date dictionary
# - ISO 8601 string
# - UNIX timestamp integer in seconds (positive or negative)
#
# If no parameter is passed, the current date will be used.
func _init(date = null) -> void:
	if date == null:
		date = OS.get_datetime()

	if date is Dictionary:
		year = date.year
		month = date.month
		day = date.day
		hour = date.hour
		minute = date.minute
		second = date.second
	elif date is String and date.find("T") >= 0 and date.find("Z") >= 0:
		var result := _parse_iso_date(date)
		year = result.year
		month = result.month
		day = result.day
		hour = result.hour
		minute = result.minute
		second = result.second
	elif date is int:
		var result := OS.get_datetime_from_unix_time(date)
		year = result.year
		month = result.month
		day = result.day
		hour = result.hour
		minute = result.minute
		second = result.second
	else:
		push_error("Unrecognized date format: " + str(date))
		year = 1970
		month = 1
		day = 1
		hour = 0
		minute = 0
		second = 0

	self.locale = TranslationServer.get_locale()

# Sets the locale for the current Date instance.
# If `locale` is null, the language from the TranslationServer will be used.
func set_locale(p_locale: String) -> void:
	var file := File.new()
	var error := file.open(
			"res://addons/godot_date/locale/" + p_locale + ".json",
			File.READ
	)

	if error != OK:
		# Fall back to English if the locale file can't be opened or doesn't exist
		# FIXME: Use `en_US` once it's available instead of `en_GB`
		var fallback_error := file.open("res://addons/godot_date/locale/en_GB.json", File.READ)

		if fallback_error != OK:
			push_error("Could not open fallback locale file at res://addons/godot_date/locale/en_GB.json.")
			assert(false)

	var json_result := JSON.parse(file.get_as_text())

	if json_result.error == OK:
		locale_strings = json_result.result
	else:
		push_error(
				"Error while parsing JSON at res://addons/godot_date/locale/{locale}.json:{line}: {message}".format({
					locale = p_locale,
					line = json_result.error_line,
					message = json_result.error_string,
				})
		)

	locale = p_locale

# Returns a new Date instance with the year set to the passed value.
func with_year(p_year: int) -> Object:
	return get_script().new({
		year = p_year,
		month = month,
		day = day,
		hour = hour,
		minute = minute,
		second = second,
	})

# Returns a new Date instance with the month set to the passed value.
func with_month(p_month: int) -> Object:
	return get_script().new({
		year = year,
		month = p_month,
		day = day,
		hour = hour,
		minute = minute,
		second = second,
	})

# Returns a new Date instance with the day set to the passed value.
func with_day(p_day: int) -> Object:
	return get_script().new({
		year = year,
		month = month,
		day = p_day,
		hour = hour,
		minute = minute,
		second = second,
	})

# Returns a new Date instance with the hour set to the passed value.
func with_hour(p_hour: int) -> Object:
	return get_script().new({
		year = year,
		month = month,
		day = day,
		hour = p_hour,
		minute = minute,
		second = second,
	})

# Returns a new Date instance with the minute set to the passed value.
func with_minute(p_minute: int) -> Object:
	return get_script().new({
		year = year,
		month = month,
		day = day,
		hour = hour,
		minute = p_minute,
		second = second,
	})

# Returns a new Date instance with the second set to the passed value.
func with_second(p_second: int) -> Object:
	return get_script().new({
		year = year,
		month = month,
		day = day,
		hour = hour,
		minute = minute,
		second = p_second,
	})

# Formats the date following the given type.
# `type` should be a LDML-like string or a localized format,
# see <https://momentjs.com/docs/#/displaying/>.
# If no type is given, an ISO 8601 date string (without timezone information)
# will be returned.
func format(type = null) -> String:
	if type != null:
		# Look for a LDML format, if there is none, format the string directly
		var date_string: String = locale_strings.formats.get(type, type)
		# Replacements for placeholders in format strings
		var replacements := {
			"YYYY": str(year),
			"MMMM": locale_strings.months.long[month - 1],
			"MMM": locale_strings.months.short[month - 1],
			"MM": str(month).pad_zeros(2),
			"M": str(month),
			"DD": str(day).pad_zeros(2),
			"D": str(day),
			"HH": str(hour).pad_zeros(2),
			"mm": str(minute).pad_zeros(2),
			"m": str(minute),
			"ss": str(second).pad_zeros(2),
			"s": str(second),
		}

		for replacement in replacements:
			date_string = date_string.replace(replacement, replacements[replacement])

		return date_string
	else:
		return "{year}-{month}-{day}T{hour}:{minute}:{second}".format({
			year = str(year),
			month = str(month).pad_zeros(2),
			day = str(day).pad_zeros(2),
			hour = str(hour).pad_zeros(2),
			minute = str(minute).pad_zeros(2),
			second = str(second).pad_zeros(2),
		})

# Returns `true` if the date is equal to the date passed as argument.
# A second precision argument can optionally be passed.
func is_same(date: Object, precision: int = Precision.SECOND) -> bool:
	if (
		precision <= Precision.YEAR and year == date.year or
		precision <= Precision.MONTH and year == date.year and month == date.month or
		precision <= Precision.DAY and year == date.year and month == date.month and day == date.day or
		precision <= Precision.HOUR and year == date.year and month == date.month and day == date.day and hour == date.hour or
		precision <= Precision.MINUTE and year == date.year and month == date.month and day == date.day and hour == date.hour and minute == date.minute or
		year == date.year and month == date.month and day == date.day and hour == date.hour and minute == date.minute and second == date.second
	):
		return true

	return false

# Returns `true` if the date is prior to the date passed as argument.
# A second precision argument can optionally be passed.
func is_before(date: Object, precision: int = Precision.SECOND) -> bool:
	if (
		year < date.year or
		precision >= Precision.MONTH and year == date.year and month < date.month or
		precision >= Precision.DAY and year == date.year and month == date.month and day < date.day or
		precision >= Precision.HOUR and year == date.year and month == date.month and day == date.day and hour < date.hour or
		precision >= Precision.MINUTE and year == date.year and month == date.month and day == date.day and hour == date.hour and minute < date.minute or
		precision >= Precision.SECOND and year == date.year and month == date.month and day == date.day and hour == date.hour and minute == date.minute and second < date.second
	):
		return true

	return false

# Returns `true` if the date is equal or prior to the date passed as argument.
# A second precision argument can optionally be passed.
func is_same_or_before(date: Object, precision: int = Precision.SECOND) -> bool:
	return is_same(date, precision) or is_before(date, precision)

# Returns `true` if the date is posterior to the date passed as argument.
# A second precision argument can optionally be passed.
func is_after(date: Object, precision: int = Precision.SECOND) -> bool:
	return !is_same_or_before(date, precision)

# Returns `true` if the date is equal or posterior to the date passed as argument.
# A second precision argument can optionally be passed.
func is_same_or_after(date: Object, precision: int = Precision.SECOND) -> bool:
	return !is_before(date, precision)

# Returns `true` if the year is a leap year.
func is_leap_year() -> bool:
	return year % 4 == 0

# Returns the number of days in the current month.
func get_days_in_month() -> int:
	match month:
		OS.MONTH_JANUARY, \
		OS.MONTH_MARCH, \
		OS.MONTH_MAY, \
		OS.MONTH_JULY, \
		OS.MONTH_AUGUST, \
		OS.MONTH_OCTOBER, \
		OS.MONTH_DECEMBER:
			return 31

		OS.MONTH_APRIL, \
		OS.MONTH_JUNE, \
		OS.MONTH_SEPTEMBER, \
		OS.MONTH_NOVEMBER:
			return 30

		OS.MONTH_FEBRUARY:
			return 29 if is_leap_year() else 28

		_:
			push_error(
					"Date has an invalid month ({month}), cannot return the number of days.".format({
						month = month,
					})
			)
			return 0

# Returns the instance's UNIX timestamp in seconds.
func unix() -> int:
	return OS.get_unix_time_from_datetime({
		year = year,
		month = month,
		day = day,
		hour = hour,
		minute = minute,
		second = second,
	})

# TODO: Handle dates with timezones
func _parse_iso_date(date: String) -> Dictionary:
	var fragments := date.split("T")
	var date_dict := fragments[0].split("-")
	var time := fragments[1].trim_suffix("Z").split(":")

	return {
		year = int(date_dict[0]),
		month = int(date_dict[1]),
		day = int(date_dict[2]),
		hour = int(time[0]),
		minute = int(time[1]),
		second = int(time[2]),
	}

func _to_string():
	return format()

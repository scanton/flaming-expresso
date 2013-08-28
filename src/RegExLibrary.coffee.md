#RegExLibrary (class) ![litCoffee Logo](https://raw.github.com/scanton/flaming-expresso/master/public/images/litCoffee-icon.png)

This is just a container class to hold a few regular expressions
we will be using in the application:

	module.exports = class RegExLibrary

##assoc (RegEx)
This regular expresssion requires one or more lowercase letters
it must start (^) and end ($) with any number of lowercase ([a-z])
letters only

		@assoc: /^[a-z]+$/

##regionLanguage (RegEx)
This regular expression requires all letters to be lowercase, it
must start with two ({2}) lowercase letters, followed by a dash '-'
followed by two more lowercase letters.  This format matches region
and language data parameters.

		@regionLanguage: /^[a-z]{2}-[a-z]{2}$/

##controller (RegEx)
This regulars expression must start and end (^ $) with lowercase
strings greater than two characters and no longer than 255 characters,
seperated by a dash '-'.  This format matches a the page controller
data parameters.

		@controller: /^[a-z]{3, 255}-[a-z]{3, 255}$/
# Write a #french_ssn_info method extracting infos from French SSN (Social Security Number) using RegExp.
# Regular Expressions are useful in two main contexts: data validation and data extraction.

# In this challenge, we are going to use RegExps to extract data from a French social security number.

  # check if there is a match with our pattern
  # if we have the match_data we need to check:
  # - if it's 1, return man, else return woman
  # - if it's over 19, return 19.., else return 20..
  # - get the month of birth based on the number
  # - get the department of birth, based on the YAML file
  # - check if the ssn_key is valid, by checking the key
  # method should return the string with all this information

# Valid French social security numbers have the following pattern:

# 1 84 12 76 451089 46

# Gender (1 == man, 2 == woman)
# Year of birth (84)
# Month of birth (12)
# Department of birth (76, basically included between 01 and 99)
# 6 random digits (451 089)
# A 2 digits key (46, equal to the remainder of the division of (97 - ssn_without_key) by 97.)
# The method must return the following strings:

# french_ssn_info("1 84 12 76 451 089 46")
# => "a man, born in December, 1984 in Seine-Maritime."
# OR
# french_ssn_info("123")
# => "The number is invalid"

require "date"
require "yaml"

PATTERN = /^(?<gender>[1-2])\s?(?<year>\d{2})\s?(?<month>0[1-9]|1[0-2])\s?(?<department>0[1-9]|[1-9][0-9])\s?\d{3}\s?\d{3}\s?(?<key>\d{2})$/


def french_ssn_info(ssn)
  match = ssn.match(PATTERN)
  #<MatchData "1 84 12 76 451 089 46" gender:"1" year:"84" month:"12" department:"76" key:"46">

  if match && valid_key?(ssn, match[:key])
    gender = match[:gender].to_i == 1 ? "man" : "woman"
    year = match[:year].to_i >= 20 ? "19#{match[:year].to_i}" : "20#{match[:year].to_i}"
    month = Date::MONTHNAMES[match[:month].to_i]
    department = YAML.load_file("data/french_departments.yml")[match[:department]]

    return "a #{gender}, born in #{month}, #{year} in #{department}."
  else
    return "The number is invalid"
  end
end

def valid_key?(ssn, key)
  ssn_without_key = ssn.delete(" ")[0..-3].to_i # including the -3 position - from 0 to -3
  # ssn_without_key = ssn.gsub(/\s+/, "")[0...-2]

  (97 - ssn_without_key) % 97 == key.to_i
end

p french_ssn_info("1 84 12 76 451 089 46")

# def get_gender(gender)
#   if gender == 1
#     return "man"
#   else
#     return "woman"
#   end
# end

#   if match && valid_key?(ssn, match[:key])
#     gender = get_gender(match[:gender].to_i)
#     year = get_year(match[:year])
#     month = get_month(match[:month])
#     department = get_department(match[:department])
#     return "a #{gender}, born in #{month}, #{year} in #{department}."
#   else
#     return "The number is invalid"
#   end
# end


# def get_year(year)
#   if year.to_i > 19
#     return "19#{year}"
#   else
#     return "20#{year}"
#   end
# end

# def get_month(month)
#   months = Date::MONTHNAMES
#   months[month.to_i]
# end

# def get_department(department)
#   departments = YAML.load_file("data/french_departments.yml")
#   departments[department]
# end






























# -*- coding: utf-8 -*-
When /захожу по адресу (.*)$/ do |path|
  visit path
end

When /нажимаю "(.*)"$/ do |button|
  click_button(button)
end

When /иду по ссылке "(.*)"$/ do |link|
  click_link(link)
end

When /ввожу "(.*)" в поле "(.*)"$/ do |value, field|
  fill_in(field, :with => value)
end

When /отмечаю галочку "(.*)"$/ do |field|
  check(field)
end

When /снимаю галочку "(.*)"$/ do |field|
  uncheck(field)
end

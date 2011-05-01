# -*- coding: utf-8 -*-

Given /^я на (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /захожу по адресу (.*)$/ do |path|
  visit path
end

When /нажимаю "(.*)"$/ do |link_or_button|
  click_on(link_or_button)
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

Then /должен увидеть сообщение "(.*)"$/ do |text|
  Then %{должен увидеть "#{text}"}
end

Then /должен увидеть "(.*)"$/ do |text|
  page.should have_content(text)
end

Then /должен увидеть \/(.*)\/$/ do |regex|
  page.should have_xpath('//*', :text => regexp)
end

Then /должен увидеть следующее:/ do |strings_table|
  strings = strings_table.raw.map(&:first)
  strings.each do |string|
    Then %{должен увидеть "#{string}"}
  end
end

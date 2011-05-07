# -*- coding: utf-8 -*-

Given /^я на (.+)$/ do |page_name|
  visit path_to(page_name)
end

Given /^я нахожусь на на (.+)$/ do |page_name|
  visit path_to(page_name)
end

Given /^я захожу на (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /захожу по адресу (.*)$/ do |path|
  visit path
end

When /нажимаю "(.*)"$/ do |link_or_button|
  click_button(link_or_button)
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

Then /^(?:|я )должен увидеть "(.*)"$/ do |text|
  page.should have_content(text)
end

Then /^должен увидеть \/(.*)\/$/ do |regex|
  page.should have_xpath('//*', :text => regexp)
end

Then /должен увидеть следующее:/ do |strings_table|
  strings = strings_table.raw.map(&:first)
  strings.each do |string|
    Then %{должен увидеть "#{string}"}
  end
end

Then /^(?:|я )должен увидеть ссылку на (.*)/ do |page_name|
  page.should have_xpath("a[@href='#{path_to(page_name)}']")
end

Then /^(?:|я )не должен (?:|у)видеть ссылку на (.*)/ do |page_name|
  page.should have_no_xpath("a[@href='#{path_to(page_name)}']")
end

Then /^(?:|я )не должен (?:|у)видеть "(.*)"/ do |text|
  page.should have_no_content(text)
end

Then /^(?:|я )должен быть в (.*)$/ do |page_name|
  current_path = URI.parse(current_url).path
  current_path.should == path_to(page_name)
end

Then /^(?:|я )должен быть перенаправлен (?:в|на) (.*)$/ do |page_name|
  steps %Q{
    Then я должен быть в #{page_name}
  }
end

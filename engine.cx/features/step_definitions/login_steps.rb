# -*- coding: utf-8 -*-
Given %r{разлогиниваюсь$}i do
  steps %Q{
    Given я захожу на главную страницу
    And захожу по адресу /users/sign_out
  }
end

Given %r{я не залогинен$}i do
  Given %{я разлогиниваюсь}
end

Given %r{залогинен как (.*)$}i do |nickname|
  Given %{я разлогиниваюсь}
  When %{я пытаюсь зарегистрироваться как #{nickname}}
  Then %{должен увидеть "Спасибо за регистрацию"}
  Given %{все отосланные к этому моменту письма прочитаны}
end

Given %r{зарегистрирован как (.*)$}i do |nickname|
  Given %{я залогинен как #{nickname}}
end

When %r{логинюсь как (.*)$} do |nickname|
  email = "#{nickname.downcase}@diesel.kg"

  When %{я захожу по адресу /login}
  When %{ввожу "#{email}" в поле "Email"}
  When %{ввожу "123456" в поле "Пароль"}
  When %{нажимаю "Войти"}
  Then %{должен быть перенаправлен в личный кабинет}
  Then %{должен увидеть "#{nickname}"}
end

Then %r{не должен быть залогинен$}i do
  steps %Q{
    When я захожу на главную страницу
    Then должен увидеть "Войти"
  }
end

Then /^я должен быть залогинен$/ do
  steps %Q{
    Then я должен увидеть "Выйти"
  }
end

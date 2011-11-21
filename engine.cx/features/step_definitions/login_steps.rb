# -*- coding: utf-8 -*-

Given %r{разлогиниваюсь$}i do
  steps %Q{
    Given я захожу на главную страницу
    And захожу по адресу /users/sign_out
  }
end

Given %r{я не залогинен$}i do
  step %{я разлогиниваюсь}
end

Given %r{залогинен как (.*)$}i do |nickname|
  step %{я разлогиниваюсь}
  step %{я пытаюсь зарегистрироваться как #{nickname}}
  step %{должен увидеть "Спасибо за регистрацию"}
  step %{все отосланные к этому моменту письма прочитаны}
end

Given %r{зарегистрирован как (.*)$}i do |nickname|
  step %{я залогинен как #{nickname}}
end

When %r{логинюсь как (.*)$} do |nickname|
  email = "#{nickname.downcase}@diesel.kg"

  step %{я захожу по адресу /login}
  step %{ввожу "#{email}" в поле "Email"}
  step %{ввожу "123456" в поле "Пароль"}
  step %{нажимаю "Войти"}
  step %{должен быть перенаправлен в личный кабинет}
  step %{должен увидеть "#{nickname}"}
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

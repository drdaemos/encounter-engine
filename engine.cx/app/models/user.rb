# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  validates_uniqueness_of :email, :message => "Пользователь с таким адресом уже зарегистрирован"
end

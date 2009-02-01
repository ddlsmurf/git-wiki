
require 'sha1'

class User

  def self.from_line(line)
    name, pass, fullname = line.split(':', 3)
    new name, pass, fullname
  end

  def self.current_user
    @@current_user
  end

  def self.current_user=(user)
    @@current_user = user
  end

  def self.find_by_login(user)
    # FIXME Quote the user for the regex
    all.find {|u| u.name == user}
  end

  def self.all
    user_page = Page.new('Users')
    content = user_page.raw_body.split("\n").map do |line|
      from_line(line)
    end
  end

  def self.authenticate(login, pass)
    return false unless user = find_by_login(login)
    return false unless user.authenticate(pass)
    self.current_user = user
    true
  end

  def initialize(name, pass, fullname)
    @name, @pass, @fullname = name, pass, fullname
  end

  def authenticate(pass)
    user_sha1 = SHA1.new(@name).to_s
    pass_sha1 = SHA1.new([user_sha1,pass].join(':')).to_s
    @pass == pass_sha1
  end

  attr_reader :name, :fullname

end

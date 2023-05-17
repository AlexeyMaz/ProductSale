class Contact
  def edit(field_name)
    if field_name == 'Телеграм'
      return false
    end
    if field_name == 'Почта'
      return false
    end
    if field_name == 'Телефон'
      return false
    else
      return true
    end
  end
end

class FIO
  def edit(field_name)
    if field_name == 'Фамилия'
      return false
    end
    if field_name == 'Имя'
      return false
    end
    if field_name == 'Отчество'
      return false
    else
      return true
    end
  end
end

class Git
  def edit(field_name)
    if field_name == 'Гит'
      return false
    else
      return true
    end
  end
end

class AddAll
  def edit(field_name)
    return false
  end
end
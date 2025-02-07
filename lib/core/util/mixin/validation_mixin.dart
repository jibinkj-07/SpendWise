mixin ValidationMixin {
  //validation of email address
  String? validateEmail(email) {
    if (email.toString().trim().isEmpty) {
      return 'Email is empty';
    } else if (!email.toString().trim().contains('@')) {
      return 'Provide a valid email address';
    }
    return null;
  }

  //validation of password
  String? validatePassword(password) {
    if (password.toString().trim().isEmpty) {
      return 'Password is empty';
    } else if (password.toString().trim().length < 6) {
      return 'Provide a password of length greater than 6';
    }
    return null;
  }

  //validation of username
  String? validateUsername(name) {
    if (name.toString().trim().isEmpty) {
      return 'Name is empty';
    } else if (name.toString().trim().length < 2) {
      return 'Provide a valid name';
    }
    return null;
  }

  //validation of phone
  String? validatePhone(phone) {
    if (phone.toString().trim().isEmpty) {
      return 'Phone number is empty';
    } else if (phone.toString().trim().length < 10) {
      return 'Provide a valid phone number';
    }
    return null;
  }

  //validation of city
  String? validateCity(city) {
    if (city.toString().trim().isEmpty) {
      return 'Provide a City or Town';
    } else if (city.toString().trim().length < 2) {
      return 'Provide a valid place';
    }
    return null;
  }
}

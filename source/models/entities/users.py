from flask_login import UserMixin
class Users(UserMixin):
    def __init__(self, id, username, password, firstname, lastname, email, physical_address, user_type,  phone="") -> None:
        self.id = id
        self.username = username
        self.password = password
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.physical_address = physical_address
        self.phone = phone
        self.user_type = user_type